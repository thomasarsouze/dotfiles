import argparse
from datetime import datetime, timezone
from pathlib import Path

import yaml
from docling.datamodel.base_models import InputFormat
from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.document_converter import (
    DocumentConverter,
    PdfFormatOption,
)
from docling_core.types.doc import ImageRefMode
from pypdf import PdfReader


def write_pdf_metadata(input_file: Path) -> str:
    reader = PdfReader(str(input_file))
    pdf_info = reader.metadata

    def get_pdf_field(field):
        if pdf_info is None:
            return None

        value = getattr(pdf_info, field, None)

        if isinstance(value, datetime):
            return value.isoformat()

        return str(value) if value else None

    metadata = {
        "source_file": input_file.name,
        "title": get_pdf_field("title") or input_file.stem,
        "author": get_pdf_field("author"),
        "subject": get_pdf_field("subject"),
        "creator": get_pdf_field("creator"),
        "producer": get_pdf_field("producer"),
        "creation_date": get_pdf_field("creation_date"),
        "modification_date": get_pdf_field("modification_date"),
        "conversion_date": datetime.now(timezone.utc).isoformat(),
    }

    # Write front matter
    frontmatter = yaml.safe_dump(
        metadata,
        allow_unicode=True,
        sort_keys=False,
    )

    return f"---\n{frontmatter}---\n\n"


def convert_pdf(input_file: Path, output_dir: Path | None, ocr: bool):
    if not input_file.exists():
        raise FileNotFoundError(f"Fichier introuvable : {input_file}")

    if input_file.suffix.lower() != ".pdf":
        raise ValueError("Le fichier doit être un PDF.")

    # Par défaut, le Markdown est généré au même endroit que le PDF
    if output_dir is None:
        output_dir = input_file.parent

    output_dir.mkdir(parents=True, exist_ok=True)

    # Nom du fichier Markdown basé sur le PDF
    output_file = output_dir / f"{input_file.stem}.md"

    # Recuperer les metadonnees
    frontmatter = write_pdf_metadata(input_file)

    # Configuration du pipeline PDF
    pipeline_options = PdfPipelineOptions(
        generate_picture_images=True,
        do_ocr=ocr,
        images_scale=2.0,
    )

    # Création du convertisseur
    converter = DocumentConverter(
        format_options={
            InputFormat.PDF: PdfFormatOption(
                pipeline_options=pipeline_options,
            )
        }
    )

    print(f"Conversion de : {input_file}")

    # Conversion du PDF
    result = converter.convert(input_file)

    # Export Markdown avec images référencées
    markdown = result.document.export_to_markdown(
        image_mode=ImageRefMode.REFERENCED,
    )

    with open(str(output_file), "w", encoding="utf-8") as f:
        f.write(frontmatter)
        f.write(markdown)

    print(f"Markdown généré : {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description="Convertit un PDF en Markdown avec Docling et exporte les images."
    )

    parser.add_argument(
        "pdf",
        type=Path,
        help="Chemin du fichier PDF à convertir",
    )

    parser.add_argument(
        "--ocr",
        type=bool,
        default=False,
        help="Activate OCR character recognition (default : False)",
    )

    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=None,
        help="Répertoire de sortie (défaut : dossier du PDF)",
    )

    args = parser.parse_args()

    convert_pdf(args.pdf, args.output, args.ocr)


if __name__ == "__main__":
    main()

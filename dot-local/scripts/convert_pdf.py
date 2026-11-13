import argparse
from pathlib import Path

from docling.datamodel.base_models import InputFormat
from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.document_converter import (
    DocumentConverter,
    PdfFormatOption,
)
from docling_core.types.doc import ImageRefMode


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
    result.document.save_as_markdown(
        str(output_file),
        image_mode=ImageRefMode.REFERENCED,
    )

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

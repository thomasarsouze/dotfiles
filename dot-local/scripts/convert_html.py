import argparse
from pathlib import Path
from urllib.parse import unquote, urlparse

# Activer le support AVIF dans Pillow
import pillow_avif  # noqa: F401
from docling.datamodel.backend_options import HTMLBackendOptions
from docling.datamodel.base_models import InputFormat
from docling.document_converter import (
    DocumentConverter,
    HTMLFormatOption,
)
from docling_core.types.doc import ImageRefMode


def convert_url(url: str, output_dir: Path):
    # Déterminer le nom du fichier depuis l'URL
    parsed_url = urlparse(url)
    filename = unquote(parsed_url.path.rstrip("/").split("/")[-1])

    if not filename:
        filename = parsed_url.netloc

    # Supprimer une éventuelle extension HTML
    filename = Path(filename).stem

    output_dir.mkdir(parents=True, exist_ok=True)

    output_file = output_dir / f"{filename}.md"

    # Configuration du backend HTML
    html_options = HTMLBackendOptions(
        fetch_images=True,
        enable_remote_fetch=True,
        source_uri=url,
    )

    # Création du convertisseur
    converter = DocumentConverter(
        format_options={
            InputFormat.HTML: HTMLFormatOption(
                backend_options=html_options,
            )
        }
    )

    print(f"Conversion de : {url}")

    # Conversion
    result = converter.convert(url)

    # Export Markdown avec images référencées
    result.document.save_as_markdown(
        str(output_file),
        image_mode=ImageRefMode.REFERENCED,
    )

    print(f"Markdown généré : {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description="Convertit une page HTML en Markdown avec Docling et exporte les images."
    )

    parser.add_argument(
        "url",
        help="URL de la page HTML à convertir",
    )

    parser.add_argument(
        "-o",
        "--output",
        default="/Users/arsouze/test_notes",
        help="Répertoire de sortie (défaut : /Users/arsouze/test_notes)",
    )

    args = parser.parse_args()

    convert_url(args.url, Path(args.output))


if __name__ == "__main__":
    main()

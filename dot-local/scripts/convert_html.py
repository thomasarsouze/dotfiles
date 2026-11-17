import argparse
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlparse

# Activer le support AVIF dans Pillow
import pillow_avif  # noqa: F401
import requests
import yaml
from docling.datamodel.backend_options import HTMLBackendOptions
from docling.datamodel.base_models import InputFormat
from docling.document_converter import (
    DocumentConverter,
    HTMLFormatOption,
)
from docling_core.types.doc import ImageRefMode


class MetadataParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.metadata = {}

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)

        if tag.lower() == "meta":
            key = attrs.get("name") or attrs.get("property")
            value = attrs.get("content")
            if key and value:
                self.metadata[key] = value


def write_url_metadata(url: str) -> str:
    # Fetch url
    response = requests.get(url, timeout=10)
    response.raise_for_status()
    html = response.text

    parser = MetadataParser()
    parser.feed(html)

    meta = parser.metadata

    metadata = {
        "source_url": url,
        "title": meta.get("og:title"),
        "author": meta.get("author"),
        "publication_date": meta.get("article:published_time"),
        "modified_date": meta.get("article:modified_time"),
        "import_date": datetime.now(timezone.utc).isoformat(),
    }

    # Write front matter
    frontmatter = yaml.safe_dump(
        metadata,
        allow_unicode=True,
        sort_keys=False,
    )

    return f"---\n{frontmatter}---\n\n"


def convert_url(url: str, output_dir: Path):
    # Déterminer le nom du fichier depuis l'URL
    parsed_url = urlparse(url)
    filename = unquote(parsed_url.path.rstrip("/").split("/")[-1])

    if not filename:
        filename = parsed_url.netloc

    filename = Path(filename).stem

    output_dir.mkdir(parents=True, exist_ok=True)

    output_file = output_dir / f"{filename}.md"

    # Recuperer les metadonnees
    frontmatter = write_url_metadata(url)

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

    # Export Markdown
    markdown = result.document.export_to_markdown(
        image_mode=ImageRefMode.REFERENCED,
    )

    with open(str(output_file), "w", encoding="utf-8") as f:
        f.write(frontmatter)
        f.write(markdown)

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

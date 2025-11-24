#!/usr/bin/env python3
"""
replace_null_data.py

Remplace toutes les occurrences de `data:null` par `data:image/webp` dans un fichier Lottie (JSON).

Usage:
  python replace_null_data.py input.json [--output output.json] [--inplace]

Options:
  --output OUTPUT   Ecrire le fichier modifié dans OUTPUT (par défaut ajoute .fixed.json)
  --inplace         Écrase le fichier d'entrée (un backup <file>.bak est créé)

Le script effectue un remplacement textuel simple (safe pour JSON) afin de préserver
les champs base64 existants. Si vous avez besoin de remplacer par une data-uri complète
avec du contenu base64, adaptez le script pour injecter les données souhaitées.
"""

import argparse
import shutil
from pathlib import Path


def replace_in_file(path: Path, output: Path | None = None, inplace: bool = False) -> Path:
    text = path.read_text(encoding='utf-8')
    if 'data:null' not in text:
        print(f"Aucune occurrence de 'data:null' trouvée dans {path}")
    new_text = text.replace('data:null', 'data:image/webp')

    if inplace:
        backup = path.with_suffix(path.suffix + '.bak')
        shutil.copy2(path, backup)
        path.write_text(new_text, encoding='utf-8')
        print(f"Fichier modifié en place. Backup: {backup}")
        return path

    if output is None:
        output = path.with_name(path.stem + '.fixed' + path.suffix)

    output.write_text(new_text, encoding='utf-8')
    print(f"Fichier sauvegardé: {output}")
    return output


def main():
    p = argparse.ArgumentParser(description='Remplace data:null par data:image/webp dans un fichier Lottie JSON')
    p.add_argument('input', help='Fichier JSON d’entrée (Lottie)')
    p.add_argument('--output', '-o', help='Fichier de sortie (optionnel)')
    p.add_argument('--inplace', action='store_true', help='Écrase le fichier d’entrée (backup créé)')
    args = p.parse_args()

    inp = Path(args.input)
    if not inp.exists():
        print(f"Fichier introuvable: {inp}")
        raise SystemExit(1)

    out = Path(args.output) if args.output else None
    replace_in_file(inp, out, inplace=args.inplace)


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""Generate/check the inventory of public theorems and their Lean axiom reports."""
import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}

def strip_comments(text):
    out, i, depth = [], 0, 0
    while i < len(text):
        if text[i:i+2] == '/-': depth += 1; i += 2
        elif depth and text[i:i+2] == '-/': depth -= 1; i += 2
        elif depth: i += 1
        elif text[i:i+2] == '--':
            j = text.find('\n', i); i = len(text) if j < 0 else j
        else: out.append(text[i]); i += 1
    if depth: raise SystemExit('Unclosed Lean block comment')
    return ''.join(out)

def inventory():
    result = []
    for p in sorted((ROOT / 'CatPhysics').glob('*.lean')):
        source = strip_comments(p.read_text())
        bad = re.findall(r'\b(?:sorry|admit|axiom|unsafe|native_decide|implemented_by)\b', source)
        if bad: raise SystemExit(f'Forbidden proof escape in {p.name}: {bad}')
        for match in re.finditer(r'^theorem\s+(\w+)\b', source, re.M):
            end = source.find(':=', match.end())
            statement = source[match.start():end].strip()
            result.append(dict(name='CatPhysics.'+match[1], module='CatPhysics.'+p.stem,
                               path=p.relative_to(ROOT).as_posix(), statement=statement))
    return result

def generate(rows):
    path = ROOT / 'CatPhysics' / 'Audit.lean'
    # Audit module is outside the default umbrella to avoid a circular import.
    path.write_text('import CatPhysics\n\n'+'\n'.join('#print axioms '+r['name'] for r in rows)+'\n')
    (ROOT / 'docs' / 'theorems.json').write_text(json.dumps(rows, indent=2)+'\n')

def check_log(rows, path):
    text = path.read_text()
    if re.search(r'\berror:', text) or 'sorryAx' in text:
        raise SystemExit('Lean audit contains an error or unfinished proof')
    for row in rows:
        name = re.escape(row['name'])
        match = re.search(r"'"+name+r"'\s+(?:does not depend on any axioms|depends on axioms:\s*\[([^]]*)\])", text)
        if not match: raise SystemExit('Missing axiom report: '+row['name'])
        axioms = {x.strip() for x in (match[1] or '').split(',') if x.strip()}
        if not axioms <= ALLOWED:
            raise SystemExit(f'Unexpected axioms for {row["name"]}: {axioms - ALLOWED}')
    print(f'{len(rows)} theorem dependency reports checked; only standard Lean foundational axioms allowed.')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--check-log', type=Path)
    args = parser.parse_args()
    rows = inventory()
    if args.generate: generate(rows)
    if args.check_log: check_log(rows, args.check_log)
    print(f'Source inventory: {len(rows)} named theorems; no unfinished proof or custom axiom declarations.')

#!/usr/bin/env python3

import plistlib
from pathlib import Path
from pprint import pprint
from string import Template


def get_kext(kext_path):
    name = kext_path.stem
    meta = kext_path / 'Contents' / 'Info.plist'
    with meta.open('rb') as file:
        meta = plistlib.load(file)
        kext = f"* {name} - v{meta['CFBundleShortVersionString']}"
    return kext


def main():

    paths = Path().rglob('*.kext')
    kexts = list(map(get_kext, paths))
    kexts = sorted(kexts)
    mark = {
        'kexts': "\n".join(kexts)
    }
    template = Path('readme-template.md')
    source = template.open('r')
    template = Template(source.read())
    output = template.substitute(mark)
    readme = Path('README.md')
    with readme.open('w+') as readme:
        readme.write(output)


if __name__ == '__main__':
    main()

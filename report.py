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

    kext_paths = Path().rglob('*.kext')
    kexts = list(map(get_kext, kext_paths))
    kexts = sorted(kexts)
    driver_paths = Path().cwd() / 'EFI' / 'CLOVER' / 'drivers64UEFI'
    drivers = driver_paths.glob('*.efi')
    drivers = sorted([f"* {d.stem}" for d in drivers])
    mark = {
        'kexts': "\n".join(kexts),
        'drivers': "\n".join(drivers),
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

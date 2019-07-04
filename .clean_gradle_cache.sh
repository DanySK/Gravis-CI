#!/bin/bash
rm -fr $HOME/.gradle/caches/*/plugin-resolution
rm -fr $HOME/.gradle/caches/*/workerMain/
rm -f $HOME/.gradle/caches/*/fileHashes/*.bin
PATTERNS=(
    '*.lock',
    'buildSrc.jar',
    'cache.properties',
    'file-access.bin',
    'user-id.txt'
)
for PATTERN in PATTERNS
do
    find "${HOME}/.gradle/caches/" -name "${PATTERN}" -type f -delete
done

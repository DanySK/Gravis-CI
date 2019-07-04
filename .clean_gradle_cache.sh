#!/bin/bash
rm -vfr $HOME/.gradle/caches/*/plugin-resolution
rm -vfr $HOME/.gradle/caches/*/workerMain/
rm -vfr $HOME/.gradle/caches/*/gradle-kotlin-dsl/*/cache/
rm -vf $HOME/.gradle/caches/*/fileHashes/*.bin
PATTERNS=(
    '*.lock'
    'buildSrc.jar'
    'cache.properties'
    'file-access.bin'
    'user-id.txt'
)
for PATTERN in ${PATTERNS[@]}
do
    find "${HOME}/.gradle/caches/" -name "${PATTERN}" -type f -delete -print
done

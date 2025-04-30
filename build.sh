#!/bin/env bash
set -eu
shopt -s nullglob
cd "$(dirname "$0")"

AS="${AS:-nasm}"
ASFLAGS=( -f elf64 )

CC="${CC:-gcc}"
CFLAGS=( -nostartfiles )

includePath=(
    "./src/include/"
    "./src/"
)

ASFLAGS+=( "${includePath[@]/#/-I}" )
CFLAGS+=( "${includePath[@]/#/-I}" )

asmSources=()
cSources=()
objects=()

BUILDDIR="${BUILDDIR:-build}"
OUTDIR="${OUTDIR:-out}"



mkdir -p "$BUILDDIR"
mkdir -p "$OUTDIR"

mapfile -t asmSources < <(find src/ -name "*.asm")
mapfile -t cSources < <(find src/ -name "*.c")

for src in "${asmSources[@]}"; do
    srcRelative="${src#src/}"
    objBase="${srcRelative%.asm}"

    obj="${BUILDDIR}/${objBase}.o"

    echo -e "\033[32m[ + ] $src -> $obj\033[0m"
    "$AS" "${ASFLAGS[@]}" "$src" -o "$obj" || {
        echo "Error assembling $src"
        exit 1
    }

    objects+=("$obj")
done

for src in "${cSources[@]}"; do
    srcRelative="${src#src/}"
    objBase="${srcRelative%.c}"

    obj="${BUILDDIR}/${objBase}.o"

    echo -e "\033[32m[ + ] $src -> $obj\033[0m"
    "$CC" "${CFLAGS[@]}" "$src" -c -o "$obj" || {
        echo "Error compiling $src"
        exit 1
    }

    objects+=("$obj")
done

"$CC" "${CFLAGS[@]}" "${objects[@]}" -o "${OUTDIR}/bubblesort" || {
    echo "Error linking executable"
    exit 1
}

echo "Build completed successfully"
echo "Executable located at ${OUTDIR}/bubblesort"

if [[ "${1:-}" == "run" ]]; then
    echo "Running executable..."
    "${OUTDIR}/bubblesort"
fi

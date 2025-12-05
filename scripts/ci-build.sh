#!/usr/bin/env bash
# Helper script to run locally or be used/adapted in CI.
set -euo pipefail

IMMORTAL_REPO="${IMMORTAL_REPO:-https://github.com/immortalwrt/immortalwrt.git}"
IMMORTAL_BRANCH="${IMMORTAL_BRANCH:-master}"
WORKDIR="$(pwd)/immortalwrt"
DEFCONFIG_PATH="${DEFCONFIG_PATH:-configs/rax3000m_defconfig}"
MAKE_JOBS="${MAKE_JOBS:-$(nproc)}"

echo "Clone ImmortalWRT if missing..."
if [ ! -d "${WORKDIR}" ]; then
  git clone --depth 1 --branch "${IMMORTAL_BRANCH}" "${IMMORTAL_REPO}" "${WORKDIR}"
fi

if [ -f "${DEFCONFIG_PATH}" ]; then
  echo "Applying defconfig ${DEFCONFIG_PATH}"
  cp "${DEFCONFIG_PATH}" "${WORKDIR}/.config"
else
  echo "No defconfig found at ${DEFCONFIG_PATH}. Make sure ${WORKDIR}/.config exists or edit script."
fi

cd "${WORKDIR}"
./scripts/feeds update -a
./scripts/feeds install -a

# Use ccache if available
export CCACHE_DIR="${CCACHE_DIR:-$(pwd)/.ccache}"
mkdir -p "${CCACHE_DIR}"
export PATH="/usr/lib/ccache:$PATH" || true

# Build
make -j"${MAKE_JOBS}" V=s

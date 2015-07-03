CPPFLAGS="${CPPFLAGS:-} -I${DEPS}/include/ncurses"
CFLAGS="${CFLAGS:-} -ffunction-sections -fdata-sections"
LDFLAGS="-L${DEPS}/lib -Wl,--gc-sections"

### NCURSES ###
_build_ncurses() {
local VERSION="5.9"
local FOLDER="ncurses-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://ftp.gnu.org/gnu/ncurses/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" --datadir="${DEST}/share" --without-shared
make
make install
popd
}

### IFSTATUS ###
_build_ifstatus() {
local VERSION="1.1.0"
local FOLDER="ifstatus"
local FILE="${FOLDER}-v${VERSION}.tar.gz"
local URL="http://ifstatus.sourceforge.net/download/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
sed -e "37i#include <stdlib.h>" -i Main.h
sed -e "s/\$^ -o \$@/\$^ -o \$@ \$(LIBS)/g" -i Makefile
make GCC="${CXX}" CFLAGS="${CFLAGS} -Wall" LDFLAGS="${LDFLAGS}" LIBS="-lncurses"
mkdir -p "${DEST}/bin"
cp -vf ifstatus "${DEST}/bin/"
popd
}

### BUILD ###
_build() {
  _build_ncurses
  _build_ifstatus
  _package
}

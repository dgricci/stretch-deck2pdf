#!/bin/bash
  
## deck2pdf tool

# Exit on any non-zero status.
trap 'exit' ERR
set -E

echo "Installing Deck2PDF ..."
export DEBIAN_FRONTEND=noninteractive
apt-get -qy update
apt-get -qy --no-install-recommends --no-install-suggests install \
    unzip
curl -fsSL "${DECK2PDF_URL}" -o deck2pdf.zip
unzip deck2pdf.zip -d /tmp
rm deck2pdf.zip
{ \
    cd /tmp/deck2pdf-${DECK2PDF_VERSION} ; \
    ./gradlew distZip ; \
    find build/distributions/ -name "*.zip" -exec unzip {} -d /usr/local \; ; \
    cd .. ; \
    rm -fr deck2pdf-${DECK2PDF_VERSION} ; \
}
{ \
    cd /usr/local ; \
    DECK2PDF_DIR="`find . -name "deck2pdf*" -type d`" ; \
    ln -s ${DECK2PDF_DIR} deck2pdf ;\
}

# uninstall and clean
apt-get purge -y \
    unzip
apt-get clean -y
rm -r /var/lib/apt/lists/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/doc-gen/*
rm -fr /usr/share/man/*

exit 0


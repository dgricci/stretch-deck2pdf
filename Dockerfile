## deck2pdf tool
FROM dgricci/javafx:1.0.0
MAINTAINER Didier Richard <didier.richard@ign.fr>
LABEL       version="1.0.0" \
            deck2pdf="v0.3.0" \
            os="Debian Stretch" \
            description="Converts various HTML5 slide decks to PDF"

## different versions - use argument when defined otherwise use defaults
ARG DECK2PDF_VERSION
ENV DECK2PDF_VERSION ${DECK2PDF_VERSION:-RELEASE_0_3_0}
ARG DECK2PDF_URL
ENV DECK2PDF_URL ${DECK2PDF_URL:-https://github.com/melix/deck2pdf/archive/$DECK2PDF_VERSION.zip}

COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && rm -f /tmp/build.sh

ENV PATH /usr/local/deck2pdf/bin:$PATH
WORKDIR /decks

CMD ["echo", "-e", "deck2pdf --profile=<defaults to deckjs> <inputfile> <outputfile>\n\tConverts various HTML5 slide decks to PDF\n\tSee https://github.com/melix/deck2pdf/ for more informations.\n"]


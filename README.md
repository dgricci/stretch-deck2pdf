% Converts various HTML5 slide decks to PDF  
% Didier Richard  
% 2018/09/09

---

# Building #

```bash
$ docker build -t dgricci/deck2pdf:$(< VERSION) .
$ docker tag dgricci/deck2pdf:$(< VERSION) dgricci/deck2pdf:latest
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/deck2pdf:$(< VERSION) .
$ docker tag dgricci/deck2pdf:$(< VERSION) dgricci/deck2pdf:latest
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg DECK2PDF_VERSION=RELEASE_0_3_0 \
    --build-arg DECK2PDF_URL=https://github.com/melix/deck2pdf/archive/RELEASE_0_3_0.zip \
    -t dgricci/deck2pdf:$(< VERSION) .
$ docker tag dgricci/deck2pdf:$(< VERSION) dgricci/deck2pdf:latest
```

# Use #

See `dgricci/stretch` README for handling permissions with dockers volumes.


```bash
$ docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -e
USER_ID=$UID -e USER_GP=`id -g` -e USER_NAME=$USER -v`pwd`:/decks -w/decks dgricci/deck2pdf deck2pdf --profile=revealjs XML1-A-slides.html XML1-A-slides.pdf
...
Exported slide 1
...
Exported slide 46
Export complete!
$ rmdir hsperfdata_ricci
```

# A shell to hide the container's usage #

As a matter of fact, typing the `docker run ...` long command is painfull !  
In the [bin directory, the deck2pdf.sh bash shell](bin/deck2pdf.sh) can be
invoked to ease the use of such a container. For instance (we suppose that the
shell script has been copied in a bin directory and is in the user's PATH) :

```bash
$ cd whatever/bin
$ ln -s deck2pdf.sh deck2pdf
$ deck2pdf --profile=revealjs XML1-A-slides.html XML1-A-slides.pdf
...
Exported slide 1 
...
Exported slide 46
Export complete!
```

Another example combining both `dgricci/pandoc` and this container :

```bash
$ pandoc -t revealjs -s --slide-level=2 --section-divs --template=template/ign-ensg-revealjs.html --email-obfuscation=none --css=css/ign.css --highlight-style=kate -V revealjs-url=externals/reveal.js -V slideNumber=true -V transition=none -o BlockChain-slides.html BlockChain-slides.md
$ deck2pdf --profile=revealjs BlockChain-slides.html BlockChain-slides.pdf
$ tree .
.
├── BlockChain-slides.html
├── BlockChain-slides.md
├── BlockChain-slides.pdf
├── css
│   └── ign.css
├── externals
│   └── reveal.js
│       └── ...
├── img
│   ├── by-nc-sa.png
│   ├── fonctionnement-blockchain1.png
│   ├── journee-Bitcoin-20161116.jpg
│   ├── passage-du-grand-cerf-20161117.jpg
│   ├── slide
│   │   ├── ign-fond-premiere.jpg
│   │   ├── ign-haut.png
│   │   ├── logo-ensg.jpg
│   │   └── logo-ign.png
│   └── XBT.png
├── template
│   └── ign-ensg-revealjs.html
└── tree.txt

1138 directories, 7056 files
```

__Et voilà !__


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o deck2pdf.pdf README.md`{.bash}


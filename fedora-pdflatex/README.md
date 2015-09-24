dockerfiles-fedora-pdflatex
===========================

This repo contains a recipe for making Docker container for pdflatex.

Check your Docker version

    # docker version

Perform the build

    # docker build -t <yourname>/pdflatex .

Check the image out.

    # docker images

Set up an alias for pdftk:

    # alias pdflatex='docker run -it --rm --privileged -v $PWD:/workdir -w /workdir/ <yourname>/pdflatex'

CD to where the files are and run it:

    # cd /path/to/files
    # pdlatex file.tex

Now file.pdf contains the output.

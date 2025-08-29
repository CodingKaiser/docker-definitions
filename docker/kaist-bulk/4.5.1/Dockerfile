########################################################
#        Renku install section - do not edit           #

FROM behaelterkaiser/renkulab-r:4.5.1 as builder

# RENKU_VERSION determines the version of the renku CLI
# that will be used in this image. To find the latest version,
# visit https://pypi.org/project/renku/#history.
ARG RENKU_VERSION=2.9.4

# Install renku from pypi or from github if a dev version
RUN if [ -n "$RENKU_VERSION" ] ; then \
    source .renku/venv/bin/activate ; \
    currentversion=$(renku --version) ; \
    if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
        pip uninstall renku -y ; \
        gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(rc[[:digit:]]\+\)*\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\4/p") ; \
        if [ -n "$gitversion" ] ; then \
            pip install --no-cache-dir --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
        else \
            pip install --no-cache-dir --force renku==${RENKU_VERSION} ;\
        fi \
    fi \
fi

# Install builder-specific packages
USER root 
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libncurses5-dev \
    pandoc \
    apt-utils \
    vim \
    libhdf5-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libgsl0-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir ${HOME}/bin

## Install samtools
RUN curl -LO https://github.com/samtools/samtools/releases/download/1.22.1/samtools-1.22.1.tar.bz2 && \
    tar -xjf samtools-1.22.1.tar.bz2 && \
    cd samtools-1.22.1 && \
    ./configure --prefix=/tmp/samtools-1.22.1 && \
    make && \ 
    make install && \
    mv /tmp/samtools-1.22.1/bin/samtools ${HOME}/bin

## Install FastQC
RUN curl -LO https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
    unzip fastqc_v0.12.1.zip && \
    chmod a+x FastQC/fastqc && \
    mv FastQC ${HOME}/bin 

## Install FastqScreen
RUN curl -LO https://github.com/StevenWingett/FastQ-Screen/archive/refs/tags/v0.16.0.tar.gz && \
	tar -xzf v0.16.0.tar.gz && \
	mv FastQ-Screen-0.16.0 ${HOME}/bin 

## Install STAR
RUN curl https://codeload.github.com/alexdobin/STAR/tar.gz/refs/tags/2.7.11b -o STAR-2.7.11b.tar.gz && \
	tar -xzf STAR-2.7.11b.tar.gz && \ 
	mv STAR-2.7.11b/bin/Linux_x86_64/STAR ${HOME}/bin 

## install fastp
RUN curl -LO http://opengene.org/fastp/fastp && \
	chmod a+x ./fastp && \
	mv ./fastp ${HOME}/bin

## install kallisto
RUN curl -LO https://github.com/pachterlab/kallisto/releases/download/v0.51.1/kallisto_linux-v0.51.1.tar.gz && \
	tar -xzf kallisto_linux-v0.51.1.tar.gz && \
	mv kallisto/kallisto ${HOME}/bin

USER ${NB_USER}

# install the R dependencies
COPY install.R /tmp/
RUN R -f /tmp/install.R

FROM behaelterkaiser/renkulab-r:4.5.1

USER root
RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add - && \
    echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list && \
    apt update && \
    apt install -y temurin-21-jdk
USER ${NB_USER}

COPY --from=builder /usr/local/lib/R/library /usr/local/lib/R/library
COPY --from=builder /usr/local/lib/R/site-library /usr/local/lib/R/site-library
COPY --from=builder ${HOME}/.renku/venv ${HOME}/.renku/venv
COPY --from=builder ${HOME}/bin ${HOME}/bin

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv pip install --system \
    multiqc

ENV PATH="${HOME}/bin:$PATH"


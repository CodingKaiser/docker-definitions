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
#             End Renku install section                #
########################################################

FROM behaelterkaiser/renkulab-r:4.5.1

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    libtbb-dev \
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

USER ${NB_USER}

# Configure R to prefer binary packages and set proper repos
RUN Rscript -e \
  'install.packages("pak", repos = file.path("https://r-lib.github.io/p/pak/stable", .Platform$pkgType, R.Version()$os, R.Version()$arch))'

# Install Seurat using pak with binary preference
RUN Rscript -e \
  'pak::pkg_install(c("cran/Seurat@5.2.1", "scRepertoire", "hdf5r", "enblacar/SCpubr", "clustree", "celldex", "SingleR", "qs2", "dittoSeq", "pheatmap"), ask=FALSE)'

COPY --from=builder ${HOME}/.renku/venv ${HOME}/.renku/venv

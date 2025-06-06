# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyterhub-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-openff-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop on OpenForceField tools."
LABEL org.opencontainers.image.licenses=MIT

ARG TARGETPLATFORM

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

RUN conda install -c conda-forge mamba
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      mamba install dglteam::dgl conda-forge::ambertools; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      mamba install dglteam::dgl conda-forge/osx-arm64::ambertools; \
    fi
RUN mamba install -c conda-forge openff-toolkit-examples openff-nagl openff-nagl-models

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/CCPBioSim/openff-workshop.git && \
    mv ccpbiosim-2023/* . && \
    rm -rf ccpbiosim-2023

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER

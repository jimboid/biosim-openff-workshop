# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM harbor.stfc.ac.uk/biosimulation-cloud/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

RUN conda install -c conda-forge mamba 
RUN mamba install -c conda-forge openff-toolkit-examples==0.14.3 openff-nagl==0.3.1 openff-nagl-models==0.1 

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/openforcefield/ccpbiosim-2023.git && \
    mv ccpbiosim-2023/* . && \
    rm -rf ccpbiosim-2023

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER

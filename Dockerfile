# Start with JupyterHub image.
FROM ccpbiosim/jupyterbase:v3.0.0

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

# Copy lab workspace
#COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER

FROM prefecthq/prefect:0.15.6-python3.7
RUN /usr/local/bin/python -m pip install --upgrade pip
WORKDIR /opt/prefect
ADD . .
RUN pip install .

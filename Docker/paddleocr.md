
* Install paddlepaddle-gpu + paddleocr
  ```shell 
  mkdir paddleocr
  cd paddleocr

  cat << EOF > Dockerfile
  FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04
  WORKDIR /workspace
  ENV PATH="/workspace/.local/bin:\$PATH"
  RUN apt update
  RUN apt install -y wget python3-pip libgl1-mesa-glx libglib2.0-0
  RUN apt clean
  RUN rm -rf /var/lib/apt/lists/*
  RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  RUN pip install --upgrade pip
  RUN pip install jupyter notebook==6.4.11 traitlets==5.9.0 jupyter_contrib_nbextensions wheel 
  RUN pip install paddlepaddle-gpu==2.6.2
  RUN pip install paddleocr==2.8.1 paddlehub==2.4.0
  RUN            mkdir -p /workspace/.cfg
  ENV JUPYTER_CONFIG_DIR="/workspace/.cfg"
  RUN jupyter contrib nbextension install
  RUN pip cache purge
  RUN       mkdir /workspace/.new_site_packages 
  ENV       PATH="/workspace/.new_site_packages/bin:\$PATH"
  ENV PIP_TARGET="/workspace/.new_site_packages"
  ENV PYTHONPATH="/workspace/.new_site_packages" 
  EOF

  docker build -t paddleocr2.8.1:notebook .
  ```
* Configure Jupyter notebook
  ```shell
  mkdir -p .cfg .new_site_packages
  cat << EOF > .cfg/jupyter_notebook_config.py
  c.NotebookApp.ip = '*'
  c.NotebookApp.token = ''
  c.NotebookApp.password = ''
  c.NotebookApp.allow_root = True
  c.NotebookApp.open_browser = False
  c.NotebookApp.notebook_dir = '/workspace'
  EOF
  ```
* Run container
  ```shell
  cat << EOF > run.sh
  docker run --gpus all -d --rm -p 9000:8888 -v $PWD:/workspace paddleocr2.8.1:notebook jupyter-notebook
  EOF
  ```
* Notes
  * One needs saving both structure and parameter of a model for inference deployment. Only parameter of a model is saved in checkpoint file. 
  * PaddleOCR includes "Text Region Detection", "Text Orientation Correction" and "Text Recognition"
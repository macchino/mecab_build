FROM ubuntu:latest
 
# update
RUN apt-get -y update && apt-get install -y \
    sudo \
    wget \
    vim
 
#install anaconda3
WORKDIR /opt
# download anaconda package and install anaconda
# archive -> https://repo.continuum.io/archive/
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.11-Linux-x86_64.sh && \
sh /opt/Anaconda3-2020.11-Linux-x86_64.sh -b -p /opt/anaconda3 && \
rm -f Anaconda3-2020.11-Linux-x86_64.sh
# set path
ENV PATH /opt/anaconda3/bin:$PATH

# mecabとmecab-ipadic-NEologdの導入
RUN apt-get install -y mecab \
    && apt-get install -y libmecab-dev \
    && apt-get install -y mecab-ipadic-utf8 \
    && apt-get install -y git \
    && apt-get install -y make \
    && apt-get install -y curl \
    && apt-get install -y xz-utils \
    && apt-get install -y file  \
    && pip install torch torchvision

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y  \
    && conda install -c conda-forge gensim \
    && pip install mecab-python3 \
    && pip install mojimoji


 
# 変数や行列の中身を確認
# 自動整形
 RUN pip install --upgrade pip &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash - &&\
    apt install nodejs \
    && pip install autopep8 \
    && pip install jupyterlab_code_formatter \
    && jupyter labextension install @ryantam626/jupyterlab_code_formatter \
    && jupyter serverextension enable --py jupyterlab_code_formatter \
    && jupyter labextension install jupyterlab-theme-solarized-dark \
    && jupyter labextension install @lckr/jupyterlab_variableinspector


WORKDIR /

RUN mkdir /notebook

# execute jupyterlab as a default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]
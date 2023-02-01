FROM ubuntu:22.04

WORKDIR ./workdir

USER root
RUN apt-get update && apt-get install -y --no-install-recommends wget build-essential libreadline-dev \ 
 libncursesw5-dev libssl-dev libsqlite3-dev libgdbm-dev libbz2-dev liblzma-dev zlib1g-dev uuid-dev libffi-dev libdb-dev
ENV TZ=Asia/Tokyo
ENV TERM xterm

#### Install python
RUN apt-get update \
 && apt-get install -y python3.10 \
 && apt-get install -y python3-pip

### Install python packages
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip \
&& pip install --no-cache-dir -r requirements.txt
# pip install git+https://github.com/lckr/jupyterlab-variableInspector.git

### Install nodejs environment and dotnet sdk
RUN apt-get -y install nodejs npm \
 && wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y dotnet-sdk-7.0 \
 && apt-get update \
 && apt-get install -y aspnetcore-runtime-7.0
### Update .NET Interactive
RUN dotnet tool install -g Microsoft.dotnet-interactive 
ENV PATH "$PATH:/root/.dotnet/tools"
RUN dotnet interactive jupyter install

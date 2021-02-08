# installation guide for raspberry PI on ubuntu server
## install ansible
### https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install software-properties-common
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
$ cd /etc/ansible/
$ ansible --version
$ sudo mkdir playbooks
```

## install Azure cli
### https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
```bash
$ sudo apt-get update
$ sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
$ curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
$ sudo apt-get update
$ sudo apt-get install azure-cli
```
## sign in to Azure with the Azure CLI
```bash
$ az login
```
## configuring Azure BLOB storage
### https://docs.microsoft.com/ru-ru/azure/storage/blobs/storage-quickstart-blobs-cli
```bash
$ az group list --out table
$ az storage account list --out table
$ az role definition list --out table | sed -nr '/blob/Ip'
$ az ad signed-in-user show --query objectId -o tsv # shows my user id without quotes
$ az ad signed-in-user show --query objectId -o tsv | az role assignment create \
     --role "Storage Blob Data Contributor" \
     --assignee @- \
     --scope subscriptions/bfba1cfe-bb32-4e4b-a147-25d51e04be11/resourceGroups/patrakhin_test/providers/Microsoft.Storage/storageAccounts/patrakhin
$ az role assignment list-changelogs
$ az storage account keys list -n patrakhin # list available keys for auth
$ export AZURE_STORAGE_KEY=r6jq+XIHSEXGC/f0opol6oCbzxRwb0zgG0Qlj4LceKSqC/PKsHMP29vfjPa3KxT+/MQU7lThhEiKX8UmdcVUGQ==
$ export AZURE_STORAGE_ACCOUNT=patrakhin
$ export AZURE_STORAGE_AUTH_MODE=key
$ az storage container create -n mytestcontainer --public-access blob
$ az storage container show -n mytestcontainer
$ az storage blob upload --container-name mytestcontainer --file ./denis_automation_catalog_tasks.json --name denis_automation_catalog_tasks.json
$ az storage blob upload --container-name mytestcontainer --file ./denis_automation_number_sys_id.json --name denis_automation_number_sys_id.json
$ az storage blob list --container-name mytestcontainer --output table
```
### Mars resources management
```bash
# resource group: RUSSIA-DEMAND-ANALYTICS-PETCARE-DEV-RG
# service (dev): russiademandanalyticspetcaredevadb
# Notebook path: Workspace/Users/peter.sosov@effem.com/TANDER_MATRIX/for_Denis_TANDER_MATRIX_ADB_NOTEBOOK (1)
# cluster to execute on: DATA_TEAM_CLUSTER

# Информация о продажах и стоках (по дням) приходит непосредственно от Tander-а
# Бизнес хочет как-то мониторить, что из того, что они хотят продавать, по факту продается
# Бизнес-планы представлены в виде матриц (точка, 1|0)
# 1 - предполагаются продажи, 0 - не предполагаются продажи
# Логика версионирования присутствует для проверки, пришел ли новый файл

$ az login
$ az dls fs list --account marsanalyticsdevadls --path / --out table
$ az dls fs list --account marsanalyticsdevadls --path /OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/UNIVERSAL_CATALOG --out table

# working on notebook (loading initial data)
$ az dls fs download --account marsanalyticsdevadls --source-path /RAW/FILES/RUSSIA_DEMAND_ANALYTICS_PETCARE/SOURCES/TANDER_MATRIX/ --destination-path ~/TANDER_MATRIX/
# installing preparing pandas
$ sudo apt update
$ sudo apt install python3-pip
$ pip3 --version
$ sudo pip3 install pandas
$ sudo pip3 install openpyxl
```

## spark tutorial https://www.youtube.com/watch?v=IQfG0faDrzE
```bash
# install java jdk
$ mkdir java && cd java
$ wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/15.0.2%2B7/0d1cfde4252546c6931946de8db48ee2/jdk-15.0.2_linux-aarch64_bin.tar.gz
$ sha256sum  jdk-15.0.2_linux-aarch64_bin.tar.gz
$ tar xvzf jdk-15.0.2_linux-aarch64_bin.tar.gz
$ cat << EOF >> ~/.bashrc
export JAVA_HOME=/home/ubuntu/jdk/jdk-15.0.2
export PATH=\$PATH:\$JAVA_HOME/bin
export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
EOF
$ source ~/.bashrc

# clone tutorial repository
$ cd ~ && git clone https://github.com/jleetutorial/python-spark-tutorial.git

# install spark
$ wget https://apache-mirror.rbc.ru/pub/apache/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
$ sha256sum spark-3.0.1-bin-hadoop2.7.tgz
$ mkdir apache-spark && cd apache-spark
$ tar xvzf spark-3.0.1-bin-hadoop2.7.tgz
$ cat << EOF >> ~/.bashrc
export SPARK_HOME=/home/ubuntu/apache-spark/spark-3.0.1-bin-hadoop2.7
export PATH=\$PATH:\$SPARK_HOME/bin
EOF
$ source ~/.bashrc
$ export PYSPARK_PYTHON=python3
```

## vim config for python IDE
```vim
" enable syntax highlighting
 syntax enable
" show line numbers
 set number
" set tabs to have 4 spaces
 set ts=4
 set tabstop=4
" indent when moving to the next line while writing code
 set autoindent
" expand tabs into spaces
 set expandtab
" when using the >> or << commands, shift lines by 4 spaces
 set shiftwidth=4
" show a visual line under the cursor's current line
 set cursorline
" show the matching part of the pair for [] {} and ()
 set showmatch
" enable all Python syntax highlighting features
 let python_highlight_all = 1
" set expandtab
 filetype indent on
" hide mouse when typing
 set mousehide
" no .swp and ~, default encoding
 set nobackup
 set noswapfile
 set encoding=utf-8
" enable 256 coulour
 set t_Co=256

" install vim plugin script: https://github.com/junegunn/vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" color theme: https://github.com/junegunn/seoul256.vim
" :PlugInstall in vim to install plugins

call plug#begin()
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
call plug#end()

" let g:seoul256_background = 233
" colo seoul256
 set bg=dark
 let g:gruvbox_termcolors='200'
 let g:gruvbox_contrast_dark='hard'
 let g:gruvbox_transparent_bg='0'
 colorscheme gruvbox
```

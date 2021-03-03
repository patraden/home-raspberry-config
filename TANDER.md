
```python
ENGAGEMENT = spark.read.format("parquet").load('/mnt/OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_ENGAGEMENT_FDM.PARQUET')
TNDR_STOCK_TT = spark.read.format("parquet").load('mnt/OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_TT.PARQUET')

STOCK_VOR = TNDR_STOCK_TT.join(FULLDICT, "Code", 'left').drop(TNDR_STOCK_TT.Branch).drop(TNDR_STOCK_TT.RC)\
                     .where(col("Year") >= 2020).where(col("ProductCode") == "1000177254")\
                     .where(col("Format").isin(["ГМ","МД"]))\
                     .where((col("Branch").contains("Белгород")) | (col("Branch").contains("Воронеж")))\
                     .where(col("RC").contains("Воронеж"))\
                     .groupBy(col("Year"),col("Week"))\
                     .agg(count(col("Code")).alias("count_code_STOCK")).orderBy(col("Year"),col("Week"), ascending = [0,0])

ENGAGEMENT_VOR = ENGAGEMENT.where(col("CalendarYearForWeek") >= 2020)\
                     .where(col("BrandCode") == "1000177254")\
                     .where(col("RC").contains("Воронеж"))\
                     .where(col("Format").isin(["ГМ","МД"]))\
                     .where((col("Filial").contains("Белгород")) | (col("Filial").contains("Воронеж")))\
                     .groupBy(col("CalendarYearForWeek"),col("CalendarWeek"))\
                     .agg(sum(col("outlet_qty_in_stock")).alias("sum_outlet_qty_in_stock"))\
                     .orderBy(col("CalendarYearForWeek"),col("CalendarWeek"), ascending = [0,0])

DICT_VOR = FULLDICT.where((col("Branch")\
                   .contains("Белгород")) | (col("Branch").contains("Воронеж")))\
                   .where(col("Format").isin(["ГМ","МД"])).where(col("RC").contains("РЦ Воронеж"))


display(DICT_VOR.groupBy(col("LatestVersion")).count())
display(STOCK_VOR.withColumn("perc", col("count_code_STOCK")/593))
display(ENGAGEMENT_VOR)
```
```python
def is_equal_schemas(a:StructType(), b:StructType()):
  """
  Helper function to compare dataframe schemas.
  Returns True if all Names, Types of each StructField match.
  False otherwise.
  """
  if len(a) != len(b):
    return False
  a_sorted = sorted(a, key = lambda x: x.name)
  b_sorted = sorted(b, key = lambda x: x.name)
  result = map(lambda x,y: x.name == y.name and x.dataType == y.dataType, a_sorted, b_sorted)
  return reduce(lambda res, x: res and x, result)

DICT_FILES = glob.glob("/dbfs" + TANDER_DIR + "DICTIONARIES/**" + DICT_WILDCARD, recursive=True)
DICT_FILES_DICT = dict(map(lambda x: (re.search(r'([0-9]{6})', x).group(0), x), DICT_FILES))
DICT_FILES_DICT_SORTED = {key: DICT_FILES_DICT[key] for key in sorted(DICT_FILES_DICT, key = lambda x: int(x))}
```

### TANDER case notes
### source of data for BI reports
* Сервер для подключения: marsanalyticsdevsqlsrv.database.windows.net
* БД для подключения: russiademandanalyticspetcaredevsqldb
* Витрины:  SL_OT_TANDER_STOCK_OL , SL_OT_TANDER_STOCK_RC


####  Source data tracking

resource type | resource name
--|--
pipe | TANDER_MATRIX_PIPE
notebook | /Users/peter.sosov@effem.com/TANDER_MATRIX/TANDER_MATRIX_ADB_NOTEBOOK
FS data set name 1 | TANDER_MATRIX_ENGAGEMENT_FDM_ADLS_DS
FS data set name 1 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_ENGAGEMENT_FDM.PARQUET
DB data set name 1 | TANDER_MATRIX_ENGAGEMENT_FDM_SQLDB_DS
DB data set name 1 path | dbo.TANDER_MATRIX_ENGAGEMENT_FDM
FS data set name 2 | TANDER_MATRIX_ANNUAL_MISMATCH_FDM_ADLS_DS
FS data set name 2 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_ANNUAL_MISMATCH_FDM.PARQUET
DB data set name 2 | TANDER_MATRIX_ANNUAL_MISMATCH_FDM_SQLDB_DS
DB data set name 2 path | dbo.TANDER_MATRIX_ANNUAL_MISMATCH_FDM
FS data set name 3 | TANDER_MATRIX_PERIOD_MISMATCH_FDM_ADLS_DS
FS data set name 3 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_PERIOD_MISMATCH_FDM.PARQUET
DB data set name 3 | TANDER_MATRIX_PERIOD_MISMATCH_FDM_SQLDB_DS
DB data set name 3 path | dbo.TANDER_MATRIX_PERIOD_MISMATCH_FDM


resource type | resource name
--|--
pipe | TANDER_ANALYTICS_PROCESS_PIPE
notebook | /KEYACCOUNT/TANDER_ANALYTICS/TANDER_LOAD_STOCKS
FS data set name 1 | TANDER_ANALYTICS_STOCK_RC_ADLS_DS
FS data set name 1 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_RC.PARQUET
DB data set name 1 | TANDER_ANALYTICS_STOCK_RC_SQLDB_DS
DB data set name 1 path | [dbo].[SL_OT_TANDER_STOCK_RC]
FS data set name 2 | TANDER_ANALYTICS_STOCK_OL_ADLS_DS
FS data set name 2 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_TT.PARQUET
DB data set name 2 | TANDER_ANALYTICS_STOCK_OL_SQLDB_DS
DB data set name 2 path | [dbo].[SL_OT_TANDER_STOCK_OL]

#### temp files (matrix & store)
```bash
az dls fs create --account marsanalyticsdevadls --path PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TMP_MATRIX.PARQUET/
az dls fs create --account marsanalyticsdevadls --path PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TMP_STORE.PARQUET/
az dls fs create --account marsanalyticsdevadls --path PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TMP_FULLPLAN.PARQUET/
```
#### fising dict files
```bash
az dls fs download --account marsanalyticsdevadls --source-path /PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/DICTIONARIES/2019/11/06/Mars_pets_food_whs_catalog_weekly_201944.txt --destination-path ~/TANDER_MATRIX/2019/11/06/Mars_pets_food_whs_catalog_weekly_201944.txt
az dls fs download --account marsanalyticsdevadls --source-path /PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/DICTIONARIES/2020/01/28/Mars_pets_food_whs_catalog_weekly_202004.txt --destination-path ~/TANDER_MATRIX/2020/01/28/Mars_pets_food_whs_catalog_weekly_202004.txt
az dls fs download --account marsanalyticsdevadls --source-path /PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/DICTIONARIES/2020/03/31/Mars_pets_food_whs_catalog_weekly_202013.txt --destination-path ~/TANDER_MATRIX/2020/03/31/Mars_pets_food_whs_catalog_weekly_202013.txt
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

## notebook documentation
```bash
# latest dictionary file mask is required:

# dictionary file structure example:
$ conv -f cp1251 -t utf8 Mars_pets_food_whs_catalog_weekly_202105.txt | more
Наименование ТТ|Код ТТ|РЦ|Филиал|Адрес|Формат|Населенный пункт
Тарантелла|590121|РЦ Пермь|Пермь Запад|614107, Пермский край, Пермь г, Хрустальная ул, дом № 11|МД|Пермь
Вельмонд|560234|РЦ Оренбург Ленина|Орск|462359, Оренбургская обл, Новотроицк г, Советская ул, дом № 66|МД|Новотроицк
Золотая|150095|РЦ Тольятти (новый)|Самара Восток|446373, Самарская обл, Красноярский р-н, Белозерки с, Дзержинского ул, дом № 40|МД|Белозерки
Канти|640048|РЦ Энгельс|Балаково|413859, Саратовская обл, Балаково г, Дружбы ул, дом № 5|МД|Балаково
...

# latest dictionary is required
```

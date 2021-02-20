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
--|--
FS data set name 1 | TANDER_MATRIX_ENGAGEMENT_FDM_ADLS_DS
FS data set name 1 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_ENGAGEMENT_FDM.PARQUET
DB data set name 1 | TANDER_MATRIX_ENGAGEMENT_FDM_SQLDB_DS
DB data set name 1 path | dbo.TANDER_MATRIX_ENGAGEMENT_FDM
--|--
FS data set name 2 | TANDER_MATRIX_ANNUAL_MISMATCH_FDM_ADLS_DS
FS data set name 2 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_ANNUAL_MISMATCH_FDM.PARQUET
DB data set name 2 | TANDER_MATRIX_ANNUAL_MISMATCH_FDM_SQLDB_DS
DB data set name 2 path | dbo.TANDER_MATRIX_ANNUAL_MISMATCH_FDM
--|--
FS data set name 3 | TANDER_MATRIX_PERIOD_MISMATCH_FDM_ADLS_DS
FS data set name 3 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_MATRIX/TANDER_MATRIX_PERIOD_MISMATCH_FDM.PARQUET
DB data set name 3 | TANDER_MATRIX_PERIOD_MISMATCH_FDM_SQLDB_DS
DB data set name 3 path | dbo.TANDER_MATRIX_PERIOD_MISMATCH_FDM


resource type | resource name
--|--
pipe | TANDER_ANALYTICS_PROCESS_PIPE
notebook | /KEYACCOUNT/TANDER_ANALYTICS/TANDER_LOAD_STOCKS
--|--
FS data set name 1 | TANDER_ANALYTICS_STOCK_RC_ADLS_DS
FS data set name 1 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_RC.PARQUET
DB data set name 1 | TANDER_ANALYTICS_STOCK_RC_SQLDB_DS
DB data set name 1 path | [dbo].[SL_OT_TANDER_STOCK_RC]
--|--
FS data set name 1 | TANDER_ANALYTICS_STOCK_OL_ADLS_DS
FS data set name 1 path | OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_TT.PARQUET
DB data set name 1 | TANDER_ANALYTICS_STOCK_OL_SQLDB_DS
DB data set name 1 path | [dbo].[SL_OT_TANDER_STOCK_OL]

#### temp files (matrix & store)
* az dls fs create --account marsanalyticsdevadls --path PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TMP_MATRIX.PARQUET/
* az dls fs create --account marsanalyticsdevadls --path PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TMP_STORE.PARQUET/
* az dls fs create --account marsanalyticsdevadls --path PROCESS/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TMP_FULLPLAN.PARQUET/

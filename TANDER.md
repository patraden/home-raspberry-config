### TANDER case notes
### source of data for BI reports
* Сервер для подключения: marsanalyticsdevsqlsrv.database.windows.net
* БД для подключения: russiademandanalyticspetcaredevsqldb
* Витрины:  SL_OT_TANDER_STOCK_OL , SL_OT_TANDER_STOCK_RC


####  Source data tracking
notebook | Sorce data |Source Data type| Target Data type | Data storage name | Database
--|--|--|--|--|--
/KEYACCOUNT/TANDER_ANALYTICS/TANDER_LOAD_STOCKS | TANDER_ANALYTICS_STOCK_RC_ADLS_DS (OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_RC.PARQUET) | FS | DB | TANDER_ANALYTICS_STOCK_RC_SQLDB_DS | [dbo].[SL_OT_TANDER_STOCK_RC]
/KEYACCOUNT/TANDER_ANALYTICS/TANDER_LOAD_STOCKS | TANDER_ANALYTICS_STOCK_OL_ADLS_DS (OUTPUT/RUSSIA_DEMAND_ANALYTICS_PETCARE/TANDER_ANALYTICS/TNDR_STOCK_TT.PARQUET) | FS | DB | TANDER_ANALYTICS_STOCK_OL_SQLDB_DS | [dbo].[SL_OT_TANDER_STOCK_OL]

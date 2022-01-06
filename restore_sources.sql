USE master;
GO

RESTORE DATABASE jade
  FROM DISK = '/var/opt/mssql/building-a-data-warehouse/Source System/jade.bak'
  WITH RECOVERY,
  MOVE 'Jade_fg1' TO '/var/opt/mssql/disk/source1/Jade_fg1.mdf',
  MOVE 'Jade_log' TO '/var/opt/mssql/disk/source1/Jade_Log.ldf';

RESTORE DATABASE jupiter
  FROM DISK = '/var/opt/mssql/building-a-data-warehouse/Source System/jupiter.bak'
  WITH RECOVERY,
  MOVE 'Jupiter_fg1' TO '/var/opt/mssql/disk/source1/Jupiter_fg1.mdf',
  MOVE 'Jupiter_log' TO '/var/opt/mssql/disk/source1/Jupiter_log.ldf';

RESTORE DATABASE webtower
  FROM DISK = '/var/opt/mssql/building-a-data-warehouse/Source System/webtower.bak'
  WITH RECOVERY,
  MOVE 'Webtower_fg1' TO '/var/opt/mssql/disk/source1/Webtower_fg1.mdf',
  MOVE 'Webtower_log' TO '/var/opt/mssql/disk/source1/Webtower_Log.ldf'

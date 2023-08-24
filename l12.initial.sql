ALTER SYSTEM SET max_connections = 100;
ALTER SYSTEM SET wal_level  = 'minimal';
ALTER SYSTEM SET archive_mode  = 'off';
ALTER SYSTEM SET max_wal_senders  = '0';
ALTER SYSTEM SET fsync  = 'off';
ALTER SYSTEM SET synchronous_commit = 'off';
ALTER SYSTEM SET work_mem = '65MB';

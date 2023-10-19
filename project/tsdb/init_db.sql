CREATE EXTENSION timescaledb;

ALTER SYSTEM SET timescaledb.telemetry_level = off;

CREATE SCHEMA iot;

SET search_path TO iot, public;

CREATE TABLE sensors
(
    "time"  timestamp not null,
    host  text,
    topic text,
    "value" double precision
);

SELECT create_hypertable('sensors', 'time', partitioning_column => 'topic', number_partitions => 1, chunk_time_interval => INTERVAL '1 month');

CREATE MATERIALIZED VIEW sensor1_daily
WITH (timescaledb.continuous) AS 
SELECT time_bucket('1day', "time"), AVG("value") AS avg_value, MIN("value") AS min_value, MAX("value") AS max_value
FROM sensors
WHERE topic = 'sensors/sensor1'
GROUP BY time_bucket('1day', "time");

SELECT add_continuous_aggregate_policy('sensor1_daily',
  start_offset => NULL,
  end_offset   => NULL,
  schedule_interval => INTERVAL '1 minutes');


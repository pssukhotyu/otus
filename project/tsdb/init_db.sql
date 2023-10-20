CREATE EXTENSION timescaledb;

ALTER SYSTEM SET timescaledb.telemetry_level = off;

CREATE SCHEMA iot;

SET search_path TO iot, public;

-- Таблица сырых показаний датчиков
CREATE TABLE sensors
(
    "time"  timestamp not null,
    host  text,
    topic text,
    "value" double precision
);

-- Создаем инфраструктуру timescaleDB для таблицы сырых данных. Секционирование будет производится по времени и имени датчика (топик mqtt). Интервал секционирования - 1 день.
SELECT create_hypertable('sensors', 'time', partitioning_column => 'topic', number_partitions => 4, chunk_time_interval => INTERVAL '1 day');


-- Добавляем дневной отчет для датчика sensors/sensor1. В отчет входят минимальное, максимальное и среднее значения. 
CREATE MATERIALIZED VIEW sensor1_daily
WITH (timescaledb.continuous) AS 
SELECT time_bucket('1day', "time"), AVG("value") AS avg_value, MIN("value") AS min_value, MAX("value") AS max_value
FROM sensors
WHERE topic = 'sensors/sensor1'
GROUP BY time_bucket('1day', "time");

-- Добавляем политику TimescaleDB отчета sensor1_daily для пополнения данными раз в минуту. Время выбрано для отладки.
-- В реальном применении имеет смысл значение schedule_interval => INTERVAL '1 day'
SELECT add_continuous_aggregate_policy('sensor1_daily',
  start_offset => NULL,
  end_offset   => NULL,
  schedule_interval => INTERVAL '1 minutes');


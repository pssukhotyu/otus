# Инфраструктура автоматизации

## Описание
Прототип инфраструктуры сбора, хранения и представления показаний датчиков и приборов.

## Запуск
```shell
docker compose up -d 
```

## Публикация показаний датчиков
```shell 
docker exec -it project-mqtt-1 mosquitto_pub -t sensors/sensor1 -u mqtt_user -P qwerty123 -m 123
```

## Заполнение тестовыми данными хранилища
```sql
INSERT INTO iot.sensors 
SELECT ts, 'host1', 'sensors/sensor1', (RANDOM() * 100)  
FROM generate_series('2020-01-01', CURRENT_TIMESTAMP, INTERVAL '1 minute') AS ts;
```
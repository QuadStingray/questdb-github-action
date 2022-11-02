#!/bin/sh

QUESTDB_VERSION=$1
QUESTDB_PORT_REST=$2
QUESTDB_PORT_PG=$3
QUESTDB_PORT_INFLUX=$4
QUESTDB_PORT_HEALTH=$5

echo "Starting QuestDb"
echo "* version [$QUESTDB_VERSION]"
echo "* port rest api [$QUESTDB_PORT_REST]"
echo "* port postgresql [$QUESTDB_PORT_PG]"
echo "* port influx line [$QUESTDB_PORT_INFLUX]"
echo "* port health [$QUESTDB_PORT_HEALTH]"

docker run --name questdb -p $QUESTDB_PORT_REST:9000 -p $QUESTDB_PORT_INFLUX:9009 -p $QUESTDB_PORT_PG:8812 -p $QUESTDB_PORT_HEALTH:9003  --detach questdb/questdb:$QUESTDB_VERSION

echo "Waiting for QuestDb to accept connections"
sleep 1
TIMER=0

until curl http://localhost:$QUESTDB_PORT_HEALTH
do
  sleep 1
  echo "."
  TIMER=$((TIMER + 1))

  if [[ $TIMER -eq 30 ]]; then
    echo "Did not initialize QuestDb within 30 seconds. Exit."
    exit 2
  fi
done

echo "Start you tests"

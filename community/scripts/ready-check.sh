#!/bin/sh

. /scripts/utils.sh

trap 'handle_sigint' SIGINT

handle_sigint() {
  echo "SIGINT signal received, exiting..."
  exit 1
}

wait_for_service() {
  SERVICE_NAME=$1
  SERVICE_URL=$2
  shift 2
  EXTRA=$@
  if [ -n "$EXTRA" ]; then
    until curl $EXTRA $SERVICE_URL > /dev/null; do
      echo "Waiting for $SERVICE_NAME to start...";
      sleep 1;
    done;
  else
    until curl --silent --head --fail $SERVICE_URL > /dev/null; do
      echo "Waiting for $SERVICE_NAME to start...";
      sleep 1;
    done;
  fi;
}

wait_for_service 'OpenVidu' 'http://223.130.139.215:7880'
wait_for_service 'Ingress' 'http://223.130.139.215:8085'
wait_for_service 'Egress' 'http://223.130.139.215:7895'
wait_for_service 'Dashboard' 'http://223.130.139.215:5000'
wait_for_service 'Minio' 'http://223.130.139.215:9000/minio/health/live'
wait_for_service 'Minio Console' 'http://223.130.139.215:9000/minio-console/health'
wait_for_service 'Mongo' 'http://223.130.139.215:27017' --connect-timeout 10 --silent

LAN_HTTP_URL=$(getDeploymentUrl http)
LAN_WS_URL=$(getDeploymentUrl ws)

for i in $(seq 1 10); do
  echo 'Starting OpenVidu... Please be patient...'
  sleep 1
done;
echo ''
echo ''
echo '========================================='
echo '🎉 OpenVidu is ready! 🎉'
echo '========================================='
echo ''
echo 'OpenVidu Server & LiveKit Server URLs:'
echo ''
echo '    - From this machine:'
echo ''
echo '        - http://223.130.139.215:7880'
echo '        - ws://223.130.139.215:7880'
echo ''
echo '    - From other devices in your LAN:'
echo ''
echo "        - $LAN_HTTP_URL"
echo "        - $LAN_WS_URL"
echo ''
echo '========================================='
echo ''
echo 'OpenVidu Developer UI (services and passwords):'
echo ''
echo '    - http://223.130.139.215:7880'
echo "    - $LAN_HTTP_URL"
echo ''
echo '========================================='

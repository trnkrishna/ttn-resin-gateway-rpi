#!/bin/bash

if [ "$PROMETHEUS_EXPORTER" = true ] ; then
    echo 'Prometheus exporter enabled.'
    
    # Start the node exporter
    mkdir /mnt/ramdisk
    mount -t tmpfs -o size=8m tmpfs /mnt/ramdisk
    cd /mnt/ramdisk
    touch /mnt/ramdisk/loragwstat.json
    /opt/ttn-gateway/run.py &

    # WORKAROUND: Add symlink, as gwexporter otherwise currently don't seem to find this file
    ln -s /mnt/ramdisk/loragwstat.json /opt/gwexporter/loragwstat.json

    export PATH=$PATH:/opt/gwexporter/bin
    node /opt/gwexporter/gwexporter.js &

    cd /etc && ./node_exporter -web.listen-address ":81"
    
else
    python /opt/ttn-gateway/run.py
fi

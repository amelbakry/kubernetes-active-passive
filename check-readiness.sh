#!/bin/bash

podhealth() {
        activepod=$(for i in 0 1; do echo active-passive-$i;done | grep -v $HOSTNAME)
        curl -I $activepod.active-passive.default.svc.cluster.local
        if [[ $? -ne 0 ]]
          then
            return 0
          else
            return 1
        fi
}

podhealth



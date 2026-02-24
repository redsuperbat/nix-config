#!/usr/bin/env fish

set PORT 8081
set URL "http://localhost:$PORT"

function cleanup --on-signal INT --on-signal TERM
    echo "\nCleaning up..."
    kubectl delete pod pgweb --ignore-not-found
    exit 0
end

kubectl run pgweb --restart=Never \
    --image=sosedoff/pgweb \
    --port=$PORT \
    --overrides='{
      "spec": {
        "containers": [{
          "name": "pgweb",
          "image": "sosedoff/pgweb",
          "ports": [{"containerPort": 8081}],
          "env": [{
            "name": "DATABASE_URL",
            "valueFrom": { "secretKeyRef": {
                "name": "app-secrets",
                "key": "DATABASE_URL"
              }
            }
          }]
        }]
      }
    }'

kubectl wait --for=condition=Ready pod/pgweb --timeout=60s

# port-forward in the background, poll in the foreground
kubectl port-forward pod/pgweb $PORT:$PORT &
set pf_pid $last_pid

echo "Waiting for $URL..."
while not curl -s --connect-timeout 1 $URL >/dev/null 2>&1
    sleep 0.2
end

echo "Opening $URL — press Ctrl+C to stop and delete the pod."
open $URL

wait $pf_pid

#!/bin/bash

RUNTIMES=("python" "nodejs" "go")
CPUS=("0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9" "1.0")
OUTFILE="benchmark-results.csv"

# Write CSV header once
if [ ! -f "$OUTFILE" ]; then
  echo "function_name,cpu,runtime,requests_per_sec,avg_latency,fastest_latency,slowest_latency,p50,p90,p95,p99,status_404" > "$OUTFILE"
fi

for RUNTIME in "${RUNTIMES[@]}"; do
  for CPU in "${CPUS[@]}"; do
    CPU_NAME=$(echo $CPU | tr '.' '-')
    FN_NAME="fibonacci-${RUNTIME}-${CPU_NAME}"
    HOST="${FN_NAME}.default.127.0.0.1.sslip.io"

    echo "📊 Benchmarking $FN_NAME ..."
    OUTPUT=$(hey -n 100 -c 10 "http://localhost:8080/?n=10" -H "Host: $HOST")

    # Extract metrics
    RPS=$(echo "$OUTPUT" | grep 'Requests/sec' | awk '{print $2}')
    AVG=$(echo "$OUTPUT" | grep 'Average' | awk '{print $2}')
    FAST=$(echo "$OUTPUT" | grep 'Fastest' | awk '{print $2}')
    SLOW=$(echo "$OUTPUT" | grep 'Slowest' | awk '{print $2}')
    P50=$(echo "$OUTPUT" | grep '^  50%' | awk '{print $3}')
    P90=$(echo "$OUTPUT" | grep '^  90%' | awk '{print $3}')
    P95=$(echo "$OUTPUT" | grep '^  95%' | awk '{print $3}')
    P99=$(echo "$OUTPUT" | grep '^  99%' | awk '{print $3}')
    CODE_404=$(echo "$OUTPUT" | grep '\[404\]' | awk '{print $2}')
    CODE_404=${CODE_404:-0} # fallback to 0 if not found

    # Append to CSV
    echo "$FN_NAME,$CPU,$RUNTIME,$RPS,$AVG,$FAST,$SLOW,$P50,$P90,$P95,$P99,$CODE_404" >> "$OUTFILE"

    echo "✅ Done with $FN_NAME"
    echo ""
  done
done

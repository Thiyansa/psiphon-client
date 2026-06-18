#!/bin/bash
sudo wget -4 -q -O /usr/local/bin/psiphon-client https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/psiphon-client
sudo chmod +x /usr/local/bin/psiphon-client
psiphon-client

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o ap0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ap0 -o eth0 -j ACCEPT
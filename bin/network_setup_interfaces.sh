sudo iw phy phy0 interface add ap0 type __ap
sudo ip link set dev ap0 address b2:27:eb:e9:70:7a
sudo ip addr add 192.168.2.240/24 dev ap0

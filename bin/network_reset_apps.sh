sudo systemctl stop wpa_supplicant
sudo systemctl disable wpa_supplicant
sudo systemctl mask wpa_supplicant

sudo systemctl stop hostapd
sudo systemctl disable hostapd
sudo systemctl mask hostapd

sudo systemctl stop dnsmasq
sudo systemctl disable dnsmasq
sudo systemctl mask dnsmasq

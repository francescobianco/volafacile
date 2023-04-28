# gambling

## Collabora

- http://localhost:9980/browser/dist/admin/admin.html

## Acquisti

- Template - <https://themeforest.net/item/gambling-casino-gambling-html-template/24432348>

## NAT e Hyper-V

- https://tewarid.github.io/2019/06/26/port-forwarding-in-hyper-v.html
  
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 25500 -Protocol TCP -InternalIPAddress "192.168.10.10" -InternalPort 3389 -NatName NATNetwork
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 25501 -Protocol TCP -InternalIPAddress "192.168.10.10" -InternalPort 81 -NatName NATNetwork
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 25502 -Protocol TCP -InternalIPAddress "192.168.10.10" -InternalPort 82 -NatName NATNetwork

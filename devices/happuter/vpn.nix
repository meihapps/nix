{ config, pkgs, ... }:
{
  age.secrets.ivpn-key.file = ../../secrets/ivpn-key.age;
  age.secrets.ivpn-psk.file = ../../secrets/ivpn-psk.age;

  systemd.services.nm-vpn-ivpn-us-los-ca3 = {
    description = "Write IVPN Los Angeles (us-ca3) NetworkManager connection";
    wantedBy = [ "multi-user.target" ];
    before = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "nm-vpn-ivpn-us-los-ca3" ''
        PRIVATE_KEY=$(cat ${config.age.secrets.ivpn-key.path})
        PRESHARED_KEY=$(cat ${config.age.secrets.ivpn-psk.path})
        install -Dm600 /dev/stdin /etc/NetworkManager/system-connections/ivpn-us-los-ca3.nmconnection << NMCONF
        [connection]
        id=IVPN Los Angeles CA3
        uuid=094bd275-294f-4fa1-8261-0f6ca838a270
        type=wireguard
        interface-name=wg-ivpn
        autoconnect=false

        [wireguard]
        private-key=$PRIVATE_KEY

        [wireguard-peer.J5+Bx84LxNPdWEhewOvBV/fGWiDluIBlAcr1QlJZil8=]
        preshared-key=$PRESHARED_KEY
        preshared-key-flags=0
        allowed-ips=0.0.0.0/0;::/0;
        endpoint=198.54.129.100:2049
        persistent-keepalive=25

        [ipv4]
        address1=172.24.212.74/32
        dns=172.16.0.1;
        method=manual

        [ipv6]
        address1=fd00:4956:504e:ffff::ac18:d44a/128
        method=manual
        NMCONF
        ${pkgs.networkmanager}/bin/nmcli connection reload 2>/dev/null || true
      '';
    };
  };
}

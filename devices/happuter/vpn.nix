{ config, pkgs, ... }:
{
  age.secrets.mullvad-sjc-wg302-key.file = ../../secrets/mullvad-sjc-wg302-key.age;

  systemd.services.nm-vpn-mullvad-sjc-wg302 = {
    description = "Write Mullvad SJC WG 302 NetworkManager connection";
    wantedBy = [ "multi-user.target" ];
    before = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "nm-vpn-mullvad-sjc-wg302" ''
        PRIVATE_KEY=$(cat ${config.age.secrets.mullvad-sjc-wg302-key.path})
        install -Dm600 /dev/stdin /etc/NetworkManager/system-connections/mullvad-sjc-wg302.nmconnection << NMCONF
        [connection]
        id=Mullvad SJC WG 302
        uuid=d322b798-edd1-4ebf-9a6f-a0371757460b
        type=wireguard
        interface-name=wg-mullvad
        autoconnect=false

        [wireguard]
        private-key=$PRIVATE_KEY

        [wireguard-peer.8wVb4HUgmpQEa5a1Q8Ff1hTDTJVaHts487bksJVugEo=]
        allowed-ips=0.0.0.0/0;::/0;
        endpoint=142.147.89.210:51820
        persistent-keepalive=25

        [ipv4]
        address1=10.74.214.49/32
        dns=100.64.0.23;
        method=manual

        [ipv6]
        address1=fc00:bbbb:bbbb:bb01::b:d630/128
        method=manual
        NMCONF
        ${pkgs.networkmanager}/bin/nmcli connection reload 2>/dev/null || true
      '';
    };
  };
}

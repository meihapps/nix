{ config, lib, pkgs, ... }:
let ip = "${pkgs.iproute2}/bin/ip"; in
{
  age.secrets.mullvad-sjc-wg302-key.file = ../../secrets/mullvad-sjc-wg302-key.age;

  # One-time cleanup: remove the old NM-managed WireGuard connection that
  # used to own the wg-mullvad interface.
  system.activationScripts.remove-mullvad-nm-connection = lib.mkAfter ''
    rm -f /etc/NetworkManager/system-connections/mullvad-sjc-wg302.nmconnection
  '';

  # Keep NM away from the natively-managed always-on tunnel interface.
  networking.networkmanager.unmanaged = [ "interface-name:wg-mullvad" ];

  # Always-on WireGuard tunnel. Owned by NixOS, not NM — stays up regardless
  # of the personal traffic toggle in Ashell's panel.
  networking.wireguard.interfaces.wg-mullvad = {
    ips = [ "10.74.214.49/32" "fc00:bbbb:bbbb:bb01::b:d630/128" ];
    privateKeyFile = config.age.secrets.mullvad-sjc-wg302-key.path;
    # Don't add allowedIPs as main-table routes — that would temporarily
    # replace the physical default route and break NM wait-online during
    # activation. We manage routing entirely via policy tables.
    allowedIPsAsRoutes = false;
    peers = [
      {
        publicKey = "8wVb4HUgmpQEa5a1Q8Ff1hTDTJVaHts487bksJVugEo=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "142.147.89.210:51820";
        persistentKeepalive = 25;
      }
    ];
    postSetup = ''
      # Populate table 201 so qbittorrent's policy route always has a target.
      ${ip} route replace default dev wg-mullvad table 201
      ${ip} -6 route replace default dev wg-mullvad table 201
    '';
    postShutdown = ''
      ${ip} route flush table 201 2>/dev/null || true
    '';
  };

  # Peerless WireGuard NM connection used as a toggle handle in Ashell's
  # network panel. No actual WireGuard traffic flows through wg-personal —
  # a dispatcher script routes personal traffic via wg-mullvad when it's up.
  systemd.services.nm-vpn-mullvad-personal = {
    description = "Write Mullvad Personal toggle NetworkManager connection";
    wantedBy = [ "multi-user.target" ];
    before = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "nm-vpn-mullvad-personal" ''
        PRIVATE_KEY=$(${pkgs.wireguard-tools}/bin/wg genkey)
        install -Dm600 /dev/stdin /etc/NetworkManager/system-connections/mullvad-personal.nmconnection << NMCONF
        [connection]
        id=Mullvad Personal
        uuid=b7a9c2d4-f1e3-4a8b-9c7d-2e5f8a1b3c6d
        type=wireguard
        interface-name=wg-personal
        autoconnect=false

        [wireguard]
        private-key=$PRIVATE_KEY

        [ipv4]
        method=disabled

        [ipv6]
        method=disabled
        NMCONF
        ${pkgs.networkmanager}/bin/nmcli connection reload 2>/dev/null || true
      '';
    };
  };
}

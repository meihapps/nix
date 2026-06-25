{ pkgs, ... }:
{
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/50-alsa-card-profile.conf" ''
      monitor.alsa.rules = [
        {
          matches = [{ device.name = "alsa_card.pci-0000_00_1f.3" }]
          actions = {
            update-props = {
              device.profile = "output:hdmi-stereo+input:analog-stereo"
            }
          }
        }
      ]
    '')
  ];
}

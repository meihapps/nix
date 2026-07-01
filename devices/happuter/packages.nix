{ pkgs, inputs, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    jdk21
    obsidian
    prismlauncher
    rocmPackages.rocm-smi
  ];
}

{ pkgs, inputs, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    jdk21
    prismlauncher
    rocmPackages.rocm-smi
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.autoclicke-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
    jdk21
    librepods
    obsidian
    prismlauncher
    rocmPackages.rocm-smi
    ungoogled-chromium
  ];
}

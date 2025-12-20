# nix

this is my nix configuration for macos.

## structure

```
.
├── flake.nix
├── darwin-configuration.nix
├── home.nix
└── modules/
    ├── dotfiles/
    │   ├── default.nix
    │   └── <app>.nix
    ├── languages/
    │   ├── default.nix
    │   └── <language>.nix
    └── <category>.nix
```

## usage

```bash
rebuild-nix

# rollback to previous configuration
rebuild-nix-rollback
```

# yunfachi's Personal NixOS Flake

## Hosts

- `iso`: portable OS without confidential information, ready for working on and deploying other hosts offline using the pre-installed `install-system` command.
- `laptop`: my laptop.
- `desktop`: my desktop.
- `vps`: a VPS running a VPN service.

## Ports

Ports in the `42800-42899` range are used when a standard port is not required (e.g. `443`). Goroawase is preferred when selecting a port, while well-standardized services such as SSH may use a conventional port ending (e.g. `42822` for SSH).

| Address            | Port  | Service         | Location |
| ------------------ | ----- | --------------- | -------- |
| `<host>.wg.ynf.sh` | 42889 | WireGuard P2P   | [`wireguard.nix`](./flake/denix/modules/networking/xray/client/wireguard.nix) |
| `<host>.wg.ynf.sh` | 42822 | OpenSSH Daemon  | — |
| `127.0.0.1`        | 42840 | Xray client API | [`default.nix`](./flake/denix/modules/networking/xray/client/default.nix) |

> Ports and addresses not listed here SHOULD NOT be used as a permanent solution.

## FAQ

### Build the ISO installer

```bash
lsblk; printf "Device: "; read -r d && [ -b "/dev/${d#/dev/}" ] && printf "Write to /dev/%s? [y/N] " "${d#/dev/}" && read -r y && { [ "$y" = y ] || [ "$y" = Y ]; } && sudo dd if=$(nix build .#nixosConfigurations.iso.config.system.build.isoImage --print-out-paths)/iso/*.iso of="/dev/${d#/dev/}" bs=4M status=progress conv=fsync
```

### Update Firefox Addons

```bash
nix run .#update-firefox-addons
```

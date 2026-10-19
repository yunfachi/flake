{
  delib,
  ...
}:
{
  denix.modules."boot" =
    { cfg, ... }:
    {
      options = with delib; {
        enable = boolOption true;
        # [ -d /sys/firmware/efi/efivars ] && echo "uefi" || echo "legacy"
        mode = enumOption [
          "uefi"
          "legacy"
        ];
      };

      nixos.ifEnabled = {
        boot.loader = {
          grub.enable = cfg.mode == "legacy";
          systemd-boot = {
            enable = cfg.mode == "uefi";
            # Prevents auth bypass.
            editor = false;
          };

          efi = {
            canTouchEfiVariables = true;
          };

          # Hide generation selection in bootloader.
          # Still can be showed if any key is pressed.
          timeout = 0;
        };
      };
    };
}

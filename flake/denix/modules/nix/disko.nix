{
  delib,
  lib,
  ...
}:
{
  denix.modules."nix" =
    { cfg, ... }:
    {
      options = with delib; {
        configureDisko = boolOption true;
      };

      myconfig.always = lib.mkIf cfg.configureDisko {
        disko.extraDatasets = {
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
          };
        };
      };

      nixos.always = lib.mkIf cfg.configureDisko {
        fileSystems."/nix".neededForBoot = true;
      };
    };
}

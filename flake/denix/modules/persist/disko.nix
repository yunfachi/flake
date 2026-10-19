{ lib, ... }:
{
  denix.modules."persist" =
    { myconfig, ... }:
    {
      myconfig.ifEnabled = {
        disko.extraDatasets = {
          "local/persist" = {
            type = "zfs_fs";
            mountpoint = myconfig.persist.persistentDir;
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };
          };
        };
      };

      nixos.ifEnabled =
        { pkgs, ... }:
        lib.mkIf myconfig.disko.enable {
          fileSystems.${myconfig.persist.persistentDir}.neededForBoot = true;

          boot.initrd.systemd = {
            enable = true;

            services.rollback-root-zfs = {
              description = "Rollback ZFS Root";
              wantedBy = [ "initrd.target" ];

              after = [ "zfs-import.target" ];
              before = [ "sysroot.mount" ];

              unitConfig.DefaultDependencies = "no";
              serviceConfig.Type = "oneshot";

              path = with pkgs; [ zfs ];
              script = ''
                zfs rollback -r zroot/local/root@blank && echo "  >> >> rollback complete << <<"
              '';
            };
          };
        };
    };
}

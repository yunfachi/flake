{
  delib,
  inputs,
  lib,
  host,
  self,
  ...
}:
{
  denix.modules."disko" =
    { cfg, myconfig, ... }:
    {
      options = with delib; {
        enable = boolOption true;

        bootSize = strOption (if host.isDesktop then "2G" else "512M");
        device = strOption;
        extraDatasets = attrsOption { };

        installPackage = boolOption host.cliFeatured;
      };

      nixos.always.imports = [
        inputs.disko.nixosModules.disko
        inputs.disko-zfs.nixosModules.default
      ];

      # https://search.nuschtos.de/options?scope=disko
      nixos.ifEnabled =
        { pkgs, ... }:
        {
          environment.systemPackages = lib.mkIf cfg.installPackage [
            inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
          ];

          disko.devices = {
            disk = {
              main = {
                type = "disk";
                inherit (cfg) device;

                imageName = "${host}_${self.lastModifiedDate}_${self.shortRev or self.dirtyShortRev or "dirty"}";
                imageSize = "3G";

                content = {
                  type = "gpt";

                  partitions =
                    (
                      if myconfig.boot.mode == "legacy" then
                        {
                          bios = {
                            size = "1M";
                            type = "EF02";
                          };

                          boot = {
                            size = cfg.bootSize;

                            content = {
                              type = "filesystem";
                              format = "ext4";
                              mountpoint = "/boot";
                            };
                          };
                        }

                      else if myconfig.boot.mode == "uefi" then
                        {
                          ESP = {
                            size = cfg.bootSize;
                            type = "EF00";

                            content = {
                              type = "filesystem";
                              format = "vfat";
                              mountpoint = "/boot";

                              mountOptions = [
                                "umask=0077"
                                "defaults"
                              ];
                            };
                          };
                        }
                      else
                        abort "unable to configure disko partitions: unknown boot mode ${lib.strings.escapeNixString myconfig.boot.mode}."
                    )
                    // {
                      luks = {
                        size = "100%";

                        content = {
                          type = "luks";
                          name = "crypted";

                          # Default password in vmWithDisko is "disko".
                          extraFormatArgs = builtins.concatLists (
                            lib.mapAttrsToList
                              (n: v: lib.optional (v != false) "--${n}${lib.optionalString (v != true) " ${toString v}"}")
                              {
                                type = "luks2";
                                cipher = "aes-xts-plain64";
                                key-size = 512;
                                hash = "sha256";
                                pbkdf = "argon2id";
                              }
                          );

                          content = {
                            type = "zfs";
                            pool = "zroot";
                          };
                        };
                      };
                    };
                };
              };
            };

            zpool = {
              zroot = {
                type = "zpool";

                rootFsOptions = {
                  # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
                  acltype = "posixacl";
                  atime = "off";
                  compression = "lz4";
                  mountpoint = "none";
                  xattr = "sa";
                };

                options.ashift = "12";

                datasets = delib.strictMergeAttrs {
                  "local" = {
                    type = "zfs_fs";
                    options.mountpoint = "none";
                  };

                  "local/root" = {
                    type = "zfs_fs";
                    mountpoint = "/";
                    options = {
                      mountpoint = "legacy";
                      "com.sun:auto-snapshot" = "false";
                    };
                    postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/local/root@blank$' || zfs snapshot zroot/local/root@blank";
                  };
                } cfg.extraDatasets;
              };
            };
          };
        };
    };
}

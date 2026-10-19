{
  delib,
  lib,
  ...
}:
{
  denix.modules."user" =
    { cfg, myconfig, ... }:
    {
      options = with delib; {
        name = strOption "yunfachi";
        home = strOption "/home/${cfg.name}";
        group = strOption "users";
        authorizedKeys = listOfOption str [ ];
        defaultGroups = listOfOption str [ "wheel" ];
        groups = listOfOption str [ ];
      };

      myconfig.always = {
        secrets.files."user/hashedPassword" = {
          recipients = [ "hosts" ];
          neededForUsers = true;
          # TODO: fix nix-secrets
          # placeholder = (pkgs.runCommand "mkpasswd-placeholder" { } ''
          #   mkpasswd ${cfg.name}
          # '').outPath;
          placeholder = "$y$j9T$CLcvgsjEsMUF6f5jk23cL.$uHI2x1rxcEVRILm3bspM31gjav4z/eHDbmKzen26UJ4";
        };

        # Probably not required when `config.system.etc.overlay.enable = true`.
        persist.files = [
          {
            file = "/etc/passwd";
            inInitrd = true;
          }
        ];
      };

      nixos.always = {
        imports = [ (lib.mkAliasOptionModule [ "user" ] [ "users" "users" cfg.name ]) ];

        services.userborn = {
          enable = true;
          importLegacyState = false;
        };

        users = {
          mutableUsers = false;
          manageLingering = true;

          users.${cfg.name} = {
            # Automatically sets:
            # - `group` to "users";
            # - `createHome` to true;
            # - `home` to "/home/«username»" (users.defaultUserHome);
            # - `useDefaultShell` to true;
            # - `isSystemUser` to false.
            isNormalUser = true;
            inherit (cfg) home group;

            linger = true;
            hashedPasswordFile = myconfig.secrets.files."user/hashedPassword".path;
            extraGroups = cfg.defaultGroups ++ cfg.groups;

            # TODO: secrets
            openssh.authorizedKeys.keys = cfg.authorizedKeys;
          };
        };
      };
    };
}

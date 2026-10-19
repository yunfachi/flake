{
  delib,
  inputs,
  ...
}:
{
  denix.modules."persist" =
    { cfg, myconfig, ... }:
    {
      options = with delib; {
        enable = boolOption myconfig.disko.enable;

        persistentDir = strOption "/persist";

        files = listOption [ ];
        directories = listOption [ ];
      };

      nixos.always = inputs.preservation.nixosModules.default;

      nixos.ifEnabled = {
        boot.initrd.systemd.enable = true;

        preservation = {
          enable = true;
          preserveAt.${cfg.persistentDir} = {
            inherit (cfg) files directories;
          };
        };
      };
    };
}

{
  delib,
  inputs,
  ...
}:
{
  denix.modules."programs.browsers.chrome" = { myconfig, ... }: {
    options = with delib; {
      enable = boolOption myconfig.programs.browsers.enable;
    };

    myconfig.ifEnabled.persist.directories = [
      {
        directory = "${myconfig.xdg.configHome}/net.imput.helium";
        mode = "0700";
        user = myconfig.user.name;
        inherit (myconfig.user) group;
      }
      {
        directory = "${myconfig.xdg.cacheHome}/net.imput.helium";
        mode = "0700";
        user = myconfig.user.name;
        inherit (myconfig.user) group;
      }
    ];

    nixos.ifEnabled = { pkgs, ... }: {
      environment.systemPackages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}

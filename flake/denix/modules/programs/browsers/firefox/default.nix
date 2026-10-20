{
  delib,
  ...
}:
{
  denix.modules."programs.browsers.firefox" = { myconfig, ... }: {
    options = with delib; {
      enable = boolOption myconfig.programs.browsers.enable;
    };

    myconfig.ifEnabled.persist.directories = [
      {
        directory = "${myconfig.xdg.configHome}/librewolf";
        mode = "0700";
        user = myconfig.user.name;
        inherit (myconfig.user) group;
      }
      {
        directory = "${myconfig.xdg.cacheHome}/librewolf";
        mode = "0700";
        user = myconfig.user.name;
        inherit (myconfig.user) group;
      }
    ];

    nixos.ifEnabled = { pkgs, ... }: {
      environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

      user.packages = [ pkgs.pywalfox-native ];

      # https://wiki.nixos.org/wiki/Firefox/en
      # TODO: wrappers
      programs.firefox = {
        enable = true;
        package = pkgs.librewolf;

        policies = {
          "3rdparty".Extensions = {

          };
        };
      };
    };
  };
}

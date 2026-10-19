{ inputs, config, ... }:
{
  imports = [ inputs.denix.flakeModule ];

  # TODO: use betterHosts
  _module.args.host = config.denixConfiguration.config.host;
  _module.args.hosts = config.denixConfiguration.config.hosts;

  denix = {
    imports = with inputs.denix.denixModules; [ betterHosts ];

    settings = {
      hosts = {
        defaultModuleSystems = [ "nixos" ];
      };
      betterHosts = {
        features = {
          features = [
            "gui"
            "cli"
            "powersave"
          ];
          defaultByHostType = {
            desktop = [
              "gui"
              "cli"
            ];
            server = [ ];
          };
        };
      };
    };
  };
}

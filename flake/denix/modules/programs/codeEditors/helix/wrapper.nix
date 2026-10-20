{
  delib,
  inputs,
  self,
  config,
  ...
}:
{
  perSystem = { pkgs, ... }: {
    packages.helix =
      (inputs.wrappers.wrapperModules.helix.apply {
        inherit pkgs;
        _module.args.pkgs = pkgs;
        imports = config.helix;
      }).wrapper;
  };

  denix.modules."programs.codeEditors.helix" = { myconfig, ... }: {
    options = with delib; { pkgs, lib, ... }: {
      package =
        packageOption
          (self.packages.${pkgs.stdenv.hostPlatform.system}.helix.configuration.apply (
            lib.optionalAttrs myconfig.programs.noctalia.enable {
              settings = {
                theme = lib.mkForce "noctalia";
              };
              extraFiles = [
                {
                  name = "themes/noctalia.toml";
                  file.path = "${myconfig.xdg.configHome}/helix/themes/noctalia.toml";
                }
              ];
            }
          )).wrapper;
    };
  };
}

{
  delib,
  host,
  inputs,
  lib,
  ...
}:
{
  denix.modules."programs.niri" = { cfg, ... }: {
    options = with delib; {
      enable = boolOption host.guiFeatured;

      settings = attrsOption { };
    };

    nixos.ifEnabled =
      {
        pkgs,
        ...
      }:
      let
        inherit (inputs.niri-nix.lib) validatedConfigFor mkNiriKDL;
        inherit (inputs.niri-nix.packages.${pkgs.stdenv.hostPlatform.system}) niri-unstable;
      in
      {
        programs.niri = {
          enable = true;
          package =
            (inputs.wrappers.wrapperModules.niri.apply {
              inherit pkgs;
              package = lib.mkForce niri-unstable;
              "config.kdl".path = validatedConfigFor niri-unstable (mkNiriKDL cfg.settings);
            }).wrapper;
        };
      };
  };
}

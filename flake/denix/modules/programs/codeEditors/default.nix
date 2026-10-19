{
  delib,
  host,
  lib,
  ...
}:
{
  denix.modules."programs.codeEditors" = { cfg, ... }: {
    options = with delib; {
      enable = boolOption host.cliFeatured;

      default = allowNull (strOption (if cfg.helix.enable then lib.getExe cfg.helix.package else null));
    };

    nixos.always = {
      environment.sessionVariables = lib.mkIf (cfg.default != null) {
        EDITOR = cfg.default;
        VISUAL = cfg.default;
      };
    };
  };
}

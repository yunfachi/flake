{
  delib,
  host,
  inputs,
  ...
}:
{
  denix.modules."terminal" = { cfg, ... }: {
    options = with delib; { pkgs, ... }: {
      enable = boolOption host.guiFeatured;

      package =
        packageOption
          (inputs.wrappers.wrapperModules.git.apply {
            inherit pkgs;
            # https://alacritty.org/config-alacritty.html
            settings = {

            };
          }).wrapper;
    };

    nixos.ifEnabled = {
      environment.systemPackages = [ cfg.package ];
    };
  };
}

{
  delib,
  host,
  inputs,
  ...
}:
{
  denix.modules."nix.nixowos" = {
    options = with delib; {
      enable = boolOption host.isDesktop;
    };

    nixos.always = [ inputs.nixowos.nixosModules.default ];

    nixos.ifEnabled = {
      nixowos.enable = true;
    };
  };
}

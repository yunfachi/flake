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

    nixos.always = {
      imports = inputs.nixowos.nixosModules.default.imports;
    };

    nixos.ifEnabled = {
      nixowos.enable = true;
    };
  };
}

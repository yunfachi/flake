{
  delib,
  host,
  inputs,
  ...
}:
{
  denix.modules."nix.nixsecauditor" = {
    options = with delib; {
      enable = boolOption host.isDesktop;
    };

    nixos.always = inputs.nixsecauditor.nixosModules.default;

    nixos.ifEnabled = {
      security.nixsecauditor.enable = true;
    };
  };
}

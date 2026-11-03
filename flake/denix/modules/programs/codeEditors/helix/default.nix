{
  delib,
  host,
  ...
}:
{
  denix.modules."programs.codeEditors.helix" =
    {
      myconfig,
      cfg,
      ...
    }:
    {
      options = with delib; {
        enable = boolOption (myconfig.programs.codeEditors.enable && host.cliFeatured);
      };

      nixos.ifEnabled = {
        environment.systemPackages = [
          cfg.package
        ];
      };
    };
}

{
  delib,
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
        enable = boolOption myconfig.programs.codeEditors.enable;
      };

      nixos.ifEnabled = {
        environment.systemPackages = [
          cfg.package
        ];
      };
    };
}

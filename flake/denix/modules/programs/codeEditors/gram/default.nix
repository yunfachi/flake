{
  delib,
  host,
  ...
}:
{
  denix.modules."programs.codeEditors.gram" =
    {
      myconfig,
      cfg,
      ...
    }:
    {
      options = with delib; {
        enable = boolOption (myconfig.programs.codeEditors.enable && host.guiFeatured);
      };

      nixos.ifEnabled = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.gram ];
      };
    };
}

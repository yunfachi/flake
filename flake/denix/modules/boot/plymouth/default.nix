{
  delib,
  ...
}:
{
  denix.modules."boot.plymouth" =
    { myconfig, ... }:
    {
      options = with delib; {
        enable = boolOption myconfig.boot.enable;
      };

      nixos.ifEnabled = {
        boot = {
          plymouth = {
            enable = true;
          };

          kernelParams = [ "splash" ];
        };
      };
    };
}

{
  delib,
  host,
  ...
}:
{
  denix.modules."networking" = {
    options = with delib; {
      enable = boolOption true;
    };

    myconfig.ifEnabled = {
      user.groups = [ "networkmanager" ];
    };

    nixos.ifEnabled = {
      networking = {
        hostName = host.name;

        # https://wiki.nixos.org/wiki/NetworkManager
        networkmanager.enable = true;
      };
    };
  };
}

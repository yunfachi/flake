{ delib, host, ... }: {
  denix.modules."nix.cache" = {
    options = with delib; {
      # TODO: by location
      enable = boolOption host.isDesktop;
    };

    nixos.ifEnabled =
      { pkgs, lib, ... }:
      {
        nix.settings = {
          substituters = [
            "https://mirror.yandex.ru/nixos"
          ];
        };
      };
  };
}

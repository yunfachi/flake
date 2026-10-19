{
  lib,
  ...
}:
{
  config = {
    helix = { pkgs, ... }: {
      extraPackages = with pkgs; [
        nixd
        nixfmt
      ];

      languages.language = lib.singleton {
        name = "nix";

        language-servers = [ "nixd" ];

        auto-format = true;
        indent = {
          tab-width = 2;
          unit = "  ";
        };
      };
    };
  };
}

{
  lib,
  ...
}:
{
  config = {
    helix = { pkgs, ... }: {
      extraPackages = with pkgs; [
        rust-analyzer
        rustfmt
        cargo
        clippy
      ];

      languages = {
        language-server.rust-analyzer.config = {
          check.command = "clippy";
        };

        language = lib.singleton {
          name = "rust";

          language-servers = [ "rust-analyzer" ];

          auto-format = true;
        };
      };
    };
  };
}

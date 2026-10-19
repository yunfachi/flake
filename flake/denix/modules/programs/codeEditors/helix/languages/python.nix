{
  lib,
  ...
}:
{
  config = {
    helix = { pkgs, ... }: {
      extraPackages = with pkgs; [
        ruff
        basedpyright
      ];

      languages = {
        language-server.basedpyright = {
          command = "basedpyright-langserver";
          args = [ "--stdio" ];
        };
        language-server.ruff = {
          command = "ruff";
          args = [
            "server"
            "--preview"
          ];
        };

        language = lib.singleton {
          name = "python";

          language-servers = [
            "basedpyright"
            "ruff"
          ];
          formatter = {
            command = "ruff";
            args = [
              "format"
              "-"
            ];
          };

          auto-format = true;
        };
      };
    };
  };
}

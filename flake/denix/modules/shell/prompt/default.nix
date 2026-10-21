{
  delib,
  inputs,
  ...
}:
{
  denix.modules."shell.prompt" = { cfg, myconfig, ... }: {
    options = with delib; { pkgs, ... }: {
      enable = boolOption myconfig.shell.enable;

      package =
        packageOption
          (inputs.wrappers.wrapperModules.starship.apply {
            inherit pkgs;
            # https://starship.rs/config/
            settings = {
              add_newline = true;
              scan_timeout = 10;

              format = builtins.concatStringsSep "" [
                "$username"
                "$hostname"
                "$battery"
                "$nix_shell"
                "$directory"
                "$git_branch"
                "$cmd_duration"
                "$character"
              ];

              # Modules.
              username = {
                show_always = false;
                style_user = "bold dimmed green";
                style_root = "bold dimmed red";
                format = "[$user]($style) at ";
              };
              hostname = {
                ssh_only = false;
                ssh_symbol = "*";
                format = "[$hostname$ssh_symbol]($style) ";
                style = "bold dimmed green";
              };
              battery = {
                format = "with [$percentage]($style) ";
                display = [
                  {
                    threshold = 100;
                    style = "bold dimmed green";
                  }
                  {
                    threshold = 30;
                    style = "bold dimmed red";
                  }
                ];
              };
              nix_shell = {
                style = "bold purple";
                format = "via [$state( \($name\))]($style) ";
                heuristic = true;
              };
              directory = {
                format = "in [$path]($style)[$read_only]($read_only_style) ";
                style = "bold dimmed green";
                read_only = "*";
                read_only_style = "dimmed red";
              };
              git_branch = {
                style = "bold dimmed green";
                format = "on [$branch]($style) ";
                ignore_branches = [
                  "master"
                  "main"
                ];
              };
              cmd_duration = {
                min_time = 1000;
                style = "bold dimmed green";
                format = "took [$duration]($style) ";
              };
              character = {
                success_symbol = "[❯](bold dimmed green)";
                error_symbol = "[❯](bold dimmed red)";
              };
            };
          }).wrapper;
    };

    nixos.ifEnabled = { lib, ... }: {
      programs.bash.promptInit =
        let
          escape = d: lib.escape [ "/" ] (toString d);
        in
        ''
          if [[ $TERM != "dumb" ]]; then
            eval -- "$(${cfg.package}/bin/starship init bash --print-full-init | sed 's/${escape cfg.package.configuration.package}/${escape cfg.package}/g')"
          fi
        '';
    };
  };
}

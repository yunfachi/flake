{ lib, ... }: {
  denix.modules."programs.niri" = { myconfig, ... }: {
    myconfig.always = {
      programs.niri.settings.binds = {
        "Mod+Return" = {
          spawn = lib.getExe myconfig.terminal.package;
          _props.repeat = false;
        };
        "Mod+Q" = {
          close-window = [ ];
          _props.repeat = false;
        };

        "Mod+V" = {
          toggle-window-floating = [ ];
          _props.repeat = false;
        };
        "Mod+F" = {
          fullscreen-window = [ ];
          _props.repeat = false;
        };

        "Alt+Tab" = {
          toggle-overview = [ ];
          _props.repeat = false;
        };
        "Mod+Escape" = {
          toggle-keyboard-shortcuts-inhibit = [ ];
          _props = {
            allow-inhibiting = false;
          };
        };
        "Mod+Shift+Slash" = {
          show-hotkey-overlay = [ ];
          _props.repeat = false;
        };

        "Mod+Tab" = {
          focus-window-down-or-column-right = [ ];
          # focus-column-first = [ ];
          _props.repeat = true;
        };
        "Mod+Shift+Tab" = {
          focus-window-up-or-column-left = [ ];
          # focus-column-last = [ ];
          _props.repeat = true;
        };

        "Mod+Left" = {
          move-column-left = [ ];
          _props.repeat = true;
        };
        "Mod+Down" = {
          move-window-down = [ ];
          _props.repeat = true;
        };
        "Mod+Up" = {
          move-window-up = [ ];
          _props.repeat = true;
        };
        "Mod+Right" = {
          move-column-right = [ ];
          _props.repeat = true;
        };

        "Mod+Shift+S".spawn-sh = "noctalia msg screenshot-region";
        "Mod+S".spawn-sh = "noctalia msg screenshot-fullscreen";
        "Mod+A".spawn-sh = "noctalia msg panel-toggle launcher";
        "Mod+L".spawn-sh = "noctalia msg session lock";
      };
    };
  };
}

{
  delib,
  lib,
  ...
}:
{
  # https://github.com/helix-editor/helix/blob/079a789e8cb08ead67f19e1971a1b7438b37354b/languages.toml#L241
  options.helix = with delib; coercedToOption anything lib.toList list [ ];

  config = {
    helix.settings = {
      # https://docs.helix-editor.com/configuration.html
      theme = "ashen";

      editor = {
        mouse = true;
        middle-click-paste = false;
        line-number = "absolute";

        cursorline = true;
        cursorcolumn = false;
        bufferline = "never";
        color-modes = true;
        popup-border = "none";

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        auto-pairs = true;

        rulers = [ 81 ];
        text-width = 80;
        indent-guides = {
          render = true;
          skip-levels = 0;
        };

        completion-timeout = 5;
        completion-replace = true;

        soft-wrap = {
          enable = true;
          max-indent-retain = 0;
          wrap-indicator = "";
        };

        gutters = [
          "diagnostics"
          "spacer"
          "diff"
          "line-numbers"
          "spacer"
        ];

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };

        statusline = {
          left = [
            "mode"
            "total-line-numbers"
            "position"
          ];

          right = [
            "spinner"
            "spacer"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];

          diagnostics = [ ];
          workspace-diagnostics = [ ];
        };
      };
    };
  };
}

{
  denix.modules."programs.niri" = { myconfig, ... }: {
    myconfig.always = {
      programs.niri.settings = {
        prefer-no-csd = [ ];

        gestures = {
          hot-corners.off = [ ];
        };

        overview = {
          zoom = 0.5;
        };

        clipboard = {
          disable-primary = [ ];
        };

        hotkey-overlay = {
          skip-at-startup = [ ];
          hide-not-bound = [ ];
        };

        input = {
          focus-follows-mouse = {
            _props.max-scroll-amount = "95%";
          };
          workspace-auto-back-and-forth = [ ];
        };

        layout = {
          gaps = 16;
          border.off = [ ];
        };

        include = [
          {
            _props.optional = true;
            _args = [ "${myconfig.xdg.configHome}/niri/noctalia.kdl" ];
          }
        ];

        window-rule = [
          {
            geometry-corner-radius = 0;
            background-effect = {
              blur = true;
              xray = false;
            };
          }
        ];

        layer-rule = [
          {
            background-effect = {
              xray = false;
            };
          }
          {
            match._props.namespace = "^noctalia-backdrop";
            place-within-backdrop = true;
          }
        ];

      };
    };
  };
}

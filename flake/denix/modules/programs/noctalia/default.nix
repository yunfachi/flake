{
  delib,
  host,
  inputs,
  ...
}:
{
  denix.modules."programs.noctalia" = _: {
    options = with delib; {
      enable = boolOption host.guiFeatured;
    };

    nixos.ifEnabled =
      {
        pkgs,
        ...
      }:
      {
        programs.noctalia = {
          enable = true;
          systemd.enable = true;

          package =
            (inputs.wrappers.wrapperModules.noctalia.apply {
              inherit pkgs;
              settings = {
                wallpaper = {
                  enabled = true;
                  transition = [ "fade" ];
                  /*
                    https://wallhaven.cc/w/w5x99p
                    https://wallhaven.cc/w/vpeek5
                    https://wallhaven.cc/w/vpe9w8
                  */
                  default.path = builtins.fetchurl {
                    url = "https://w.wallhaven.cc/full/85/wallhaven-85mqwy.png";
                    sha256 = "sha256-T9mfgycOnOwgyC44MwoJcTeb/E16hX6GYWsYisRcXuc=";
                  };
                };

                backdrop = {
                  enabled = true;
                  blur_intensity = 0.4;
                  tint_intensity = 0.25;
                };

                bar.default = {
                  background_opacity = 0.6;
                  border_width = 1.0;
                  capsule_radius = 0;
                  margin_ends = 600;
                  margin_edge = 4;
                  padding = 12;
                  radius = 0;
                  reserve_space = false;
                  smart_auto_hide = true;
                  thickness = 32;
                  start = [
                    "workspaces"
                    "privacy"
                  ];
                  center = [
                    "clock"
                    "spacer_2"
                    "media"
                  ];
                  end = [
                    "volume"
                    "battery"
                  ];
                };

                desktop_widgets.enabled = false;

                dock = {
                  enabled = true;
                  auto_hide = true;
                  position = "right";
                  reserve_space = false;
                  background_opacity = 0.6;
                  inactive_opacity = 0.6;
                  inactive_scale = 1.0;
                  magnification_scale = 1.2;
                  border_width = 1.0;
                  cross_axis_padding = 4;
                  main_axis_padding = 4;
                  margin_edge = 4;
                  radius = 0;
                  icon_size = 40;
                  item_spacing = 0;
                };

                control_center = {
                  width = 810;
                  shortcuts = [
                    { type = "wifi"; }
                    { type = "bluetooth"; }
                    { type = "dark_mode"; }
                    { type = "mic_mute"; }
                    { type = "nightlight"; }
                    { type = "wallpaper"; }
                  ];
                };

                lockscreen_widgets.enabled = false;

                nightlight.enabled = true;

                notification.background_opacity = 0.6;

                osd.background_opacity = 0.6;

                plugins.enabled = [ "noctalia/kaomoji" ];

                shell = {
                  corner_radius_scale = 0.0;
                  niri_overview_type_to_launch_enabled = true;
                  polkit_agent = true;

                  animation = {
                    speed = 1.8;
                  };

                  launcher = {
                    app_grid = true;

                    providers = {
                      session.global = true;
                    };
                  };

                  panel = {
                    clipboard_position = "auto";
                    open_near_click_clipboard = true;
                    control_center_placement = "floating";
                    launcher_position = "auto";
                    session_placement = "floating";
                    transparency_mode = "glass";
                    wallpaper_placement = "floating";
                  };

                  screnshot = {
                    show_cursor = true;
                  };

                  session = {
                    grid = true;
                  };
                };

                theme = {
                  mode = "dark";
                  source = "wallpaper";
                  wallpaper_scheme = "m3-tonal-spot";

                  templates = {
                    builtin_ids = [
                      "alacritty"
                      "gtk4"
                      "helix"
                      "niri"
                      "qt"
                    ];
                    community_ids = [
                      "feishin"
                      "pywalfox-beta4"
                      "ungoogled-chromium"
                      "prismlauncher"
                      "steam"
                      "obs"
                      "fcitx5"
                    ];
                  };
                };

                weather.enabled = false;

                widget = {
                  workspaces = {
                    active_pill_size = 1.8;
                    pill_scale = 0.8;
                    scroll_repeat = "steps";
                    show_labels = false;
                    hide_when_empty = false;
                  };
                  privacy = {
                    hide_inactive = true;
                  };

                  clock = {
                    anchor = true;
                  };

                  spacer_2 = {
                    length = 12;
                    type = "spacer";
                  };

                  media = {
                    art_size = 18;
                    max_length = 200;
                    scroll_repeat = "steps";
                    title_scroll = "on_hover";
                  };

                  volume = {
                    scroll_repeat = "steps";
                  };
                };
              };
            }).wrapper;
        };
      };
  };
}

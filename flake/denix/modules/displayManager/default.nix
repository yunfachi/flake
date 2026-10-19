{
  delib,
  host,
  lib,
  ...
}:
{
  denix.modules."displayManager" = {
    options = with delib; {
      enable = boolOption host.guiFeatured;
    };

    nixos.ifEnabled = { pkgs, ... }: {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        # greeterManagesPlymouth = true;
        settings = {
          default_session = {
            user = "greeter";
            command =
              lib.getExe' pkgs.tuigreet "tuigreet"
              + " --config ${
                 pkgs.writers.writeTOML "tuigreet-config.toml" {
                   display = {
                     show_time = true;
                     time_format = "%T - %a %e";

                     custom_title = " (>_<) ";
                     greeting = ''
                       You don't need to work 12 hours a day you just need to steal
                                                                   - Steve Jobless'';
                     align_greeting = "center";

                     battery = true;
                   };

                   user_menu = {
                     enabled = true;
                   };

                   secret.mode = "hidden";

                   status_bar = {
                     show_background = false;
                   };

                   theme = {
                     # text = "green";
                     # time = "green";
                     # container = "black";
                     # border = "white";
                     # title = "cyan";
                     # greet = "yellow";
                     # prompt = "green";
                     # input = "white";
                     # action = "bright-blue";
                     # button = "bright-red";
                   };
                 }
               }";
          };
        };
      };
    };
  };
}

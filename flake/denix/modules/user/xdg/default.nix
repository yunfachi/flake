{
  delib,
  host,
  lib,
  ...
}:
{
  denix.modules."xdg" =
    { myconfig, cfg, ... }:
    let
      user = myconfig.user.name;
      inherit (myconfig.user) group home;
    in
    {
      options = with delib; {
        enable = boolOption host.guiFeatured;

        configHome = strOption (home + "/.config");
        cacheHome = strOption (home + "/.cache");
        dataHome = strOption (home + "/.local/share");
        stateHome = strOption (home + "/.local/state");

        userDirs = {
          download = strOption (home + "/download");
          desktop = strOption (home + "/files/desktop");
          documents = strOption (home + "/files/documents");
          publicShare = strOption (home + "/files/publicshare");
          projects = strOption (home + "/files/projects");
          templates = strOption (home + "/files/templates");
          music = strOption (home + "/media/music");
          pictures = strOption (home + "/media/pictures");
          videos = strOption (home + "/media/videos");
        };
      };

      myconfig.ifEnabled = {
        persist.directories = lib.mapAttrsToList (_: v: {
          directory = v;
          mode = "0700";
          inherit user group;
          configureParent = false;
        }) cfg.userDirs;
      };

      nixos.ifEnabled = { pkgs, ... }: {
        user.packages = [ pkgs.xdg-user-dirs ];

        # environment.sessionVariables = {
        #   XDG_CONFIG_HOME = cfg.configHome;
        #   XDG_CACHE_HOME = cfg.cacheHome;
        #   XDG_DATA_HOME = cfg.dataHome;
        #   XDG_STATE_HOME = cfg.stateHome;

        #   XDG_DOWNLOAD_DIR = cfg.downloadDir;
        #   XDG_DESKTOP_DIR = cfg.desktopDir;
        #   XDG_DOCUMENTS_DIR = cfg.documentsDir;
        #   XDG_PUBLICSHARE_DIR = cfg.publicShareDir;
        #   XDG_PROJECTS_DIR = cfg.projectsDir;
        #   XDG_TEMPLATES_DIR = cfg.templatesDir;
        #   XDG_MUSIC_DIR = cfg.musicDir;
        #   XDG_PICTURES_DIR = cfg.picturesDir;
        #   XDG_VIDEOS_DIR = cfg.videosDir;
        # };

        systemd.tmpfiles.settings.xdg-dirs =
          let
            user = myconfig.user.name;
            inherit (myconfig.user) group;
          in
          {
            "${cfg.configHome}/user-dirs.conf".F = {
              mode = "0555";
              inherit user group;
              argument = "enabled=False";
            };
            "${cfg.configHome}/user-dirs.dirs".F = {
              mode = "0555";
              inherit user group;
              argument = lib.generators.toKeyValue { } (
                lib.mapAttrs' (n: v: lib.nameValuePair "XDG_${lib.toUpper n}_DIR" ''"${v}"'') cfg.userDirs
              );
            };
          }
          //
            lib.genAttrs'
              (builtins.concatMap
                (
                  let
                    parentsUntilHome =
                      path:
                      (
                        if builtins.dirOf path == myconfig.user.home then
                          [ ]
                        else
                          parentsUntilHome (builtins.dirOf path) ++ [ (builtins.dirOf path) ]
                      );
                  in
                  path: [ path ] ++ parentsUntilHome path
                )
                (
                  [
                    cfg.configHome
                    cfg.cacheHome
                    cfg.dataHome
                    cfg.stateHome
                  ]
                  ++ (
                    if myconfig.persist.enable then
                      builtins.concatMap (
                        path: if builtins.dirOf path == myconfig.user.home then [ ] else [ (builtins.dirOf path) ]
                      ) (builtins.attrValues cfg.userDirs)
                    else
                      builtins.attrValues cfg.userDirs
                  )
                )
              )
              (
                v:
                lib.nameValuePair v {
                  d = {
                    mode = "0700";
                    inherit user group;
                  };
                }
              );
      };
    };
}

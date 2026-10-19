{
  lib,
  root,
  ...
}:
let
  extensions = [
    # keep-sorted start
    "bitwarden-password-manager"
    "clearurls"
    "darkreader"
    "pywalfox"
    "sponsorblock"
    "steam-database"
    "ublock-origin"
    "yomitan"
    # keep-sorted end
  ];
in
{
  perSystem = { pkgs, ... }: {
    apps.update-firefox-addons.program = pkgs.writeShellScriptBin "update-firefox-addons" "${lib.getExe pkgs.nix} run https://git.sr.ht/~rycee/mozilla-addons-to-nix/archive/master.tar.gz --extra-experimental-features 'flakes nix-command' -- ${
      builtins.toFile "manifest.json" (builtins.toJSON (map (slug: { inherit slug; }) extensions))
    } .${lib.removePrefix (toString root) (toString ./generated.nix.g)}";
  };

  denix.modules."programs.browsers.firefox" = {
    nixos.ifEnabled =
      { pkgs, ... }:
      let
        generatedExtensions =
          let
            buildMozillaXpiAddon =
              {
                addonId,
                url,
                sha256,
                ...
              }:
              pkgs.fetchurl { inherit url sha256; } // { inherit addonId; };
          in
          import ./generated.nix.g {
            inherit buildMozillaXpiAddon lib;
            inherit (pkgs) fetchurl stdenv;
          };
      in
      {
        programs.firefox = {
          policies.ExtensionSettings = lib.mapAttrs' (_: extension: {
            name = extension.addonId;
            value = {
              installation_mode = "force_installed";
              install_url = "file://${extension}";
            };
          }) generatedExtensions;
        };
      };
  };
}

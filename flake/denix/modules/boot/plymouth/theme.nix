{
  self,
  ...
}:
{
  denix.modules."boot.plymouth" = {
    nixos.ifEnabled =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        boot.plymouth = {
          theme = "framework-penguin";
          themePackages = lib.singleton (
            self.packages.${pkgs.stdenv.hostPlatform.system}.plymouth-framework-penguin.override {
              logo = config.boot.plymouth.logo;
            }
          );
        };
      };
  };

  perSystem = { pkgs, ... }: {
    packages.plymouth-framework-penguin = pkgs.callPackage (
      {
        stdenvNoCC,
        fetchFromGitHub,
        unstableGitUpdater,
        lib,
        logo ? null,
      }:
      stdenvNoCC.mkDerivation {
        pname = "plymouth-framework-penguin";
        version = "0-unstable-2026-08-25";

        src = fetchFromGitHub {
          owner = "ygurin";
          repo = "framework-penguin";
          rev = "13c0295d65b0ce45116decdc69fadf4679c7d9a7";
          hash = "sha256-GrfUZyhyWXfJHSjFxv7LA7OQmiRaWEyvVzR16RO2PUM=";
        };

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall

          themeDir="$out/share/plymouth/themes/framework-penguin"
          mkdir -p "$themeDir"

          cp -r $src/{framework-penguin.plymouth,framework-penguin.script,bullet.png,entry.png,lock.png,frames} "$themeDir"

          substituteInPlace "$themeDir/framework-penguin.plymouth" \
            --replace-fail "/usr/" "$out/"

          ${lib.optionalString (logo != null) ''
            install -Dm644 ${lib.escapeShellArg (toString logo)} "$themeDir/watermark.png"
          ''}

          runHook postInstall
        '';

        passthru.updateScript = unstableGitUpdater { };

        meta = {
          description = "Plymouth boot screen featuring Framework follow the penguin animation";
          homepage = "https://github.com/ygurin/framework-penguin";
          license = lib.licenses.mit;
          platforms = lib.platforms.linux;
          maintainers = with lib.maintainers; [ yunfachi ];
        };
      }
    ) { };
  };
}

{
  self,
  lib,
  host,
  ...
}:
let
  flakeOutPaths =
    let
      collector =
        parent:
        map (
          child:
          [ child.outPath ] ++ (if child ? inputs && child.inputs != { } then (collector child) else [ ])
        ) (lib.attrValues parent.inputs);
    in
    lib.unique (lib.flatten (collector self));

  dependencies =
    builtins.concatLists (
      lib.mapAttrsToList (
        name: configuration:
        lib.optionals (name != host.name) [
          configuration.config.system.build.toplevel
          # configuration.config.system.build.toplevel.drvPath
          configuration.config.system.build.diskoScript
          # configuration.config.system.build.diskoScript.drvPath
          configuration.pkgs.stdenv.drvPath

          # https://github.com/NixOS/nixpkgs/blob/f2fd33a198a58c4f3d53213f01432e4d88474956/nixos/modules/system/activation/top-level.nix#L342
          configuration.pkgs.perlPackages.ConfigIniFiles
          configuration.pkgs.perlPackages.FileSlurp

          (configuration.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
        ]
      ) self.nixosConfigurations
    )
    ++ flakeOutPaths;
in
{
  denix.hosts."iso" = {
    type = "desktop";

    myconfig.ifEnabled = {
      disko.enable = false;
      boot.enable = false;
    };

    nixos.ifEnabled =
      {
        lib,
        modulesPath,
        pkgs,
        config,
        ...
      }:
      {
        image = {
          baseName = lib.mkForce "${host}_${self.lastModifiedDate}_${
            self.shortRev or self.dirtyShortRev or "dirty"
          }";
        };
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];
        environment.etc."install-closure".source = "${
          pkgs.closureInfo { rootPaths = dependencies; }
        }/store-paths";
        environment.systemPackages = [
          (pkgs.writeShellScriptBin "install-system" ''
            set -eux
            exec ${pkgs.disko}/bin/disko-install --flake "${self}#$1" "''${@:2}"
          '')
        ];
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = config.system.nixos.release;

        security.nix-secrets.ciMode = {
          enableDangerously = lib.mkForce true;
          usePlaceholders = true;
        };
      };
  };
}

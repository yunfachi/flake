{ inputs, ... }: {
  denix.modules."nix" = {
    myconfig.always = {
      persist.directories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
    };

    nixos.always =
      { pkgs, lib, ... }:
      {
        nix = {
          package = lib.mkForce pkgs.nixVersions.latest;

          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "blake3-hashes"
              "auto-allocate-uids"
              "cgroups"
            ];
            trusted-users = lib.mkForce [
              "root"
              "@wheel"
            ];

            auto-allocate-uids = true;
            flake-registry = "";
            warn-dirty = false;
            log-lines = 50;
            # secret-key-files = TODO;
          };

          channel.enable = false;
          nixPath = [ "nixpkgs=flake:nixpkgs" ];
          registry.nixpkgs.flake = inputs.nixpkgs;
        };
      };
  };
}

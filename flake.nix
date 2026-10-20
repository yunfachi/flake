{
  # Code comments be like:
  description = "yunfachi's flake";

  inputs = {
    /**
      Flake Core.

      Fundamental inputs required to evaluate the flake.
    */
    # keep-sorted start group_start_regex=["^\\s*(?:\"[^\"]*\"|[a-zA-Z0-9_-]*)\\.url\\b"] newline_separated=yes
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixpkgs.url = "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";
    # keep-sorted end

    /**
      Flake Parts.

      Supporting tooling used to compose flake outputs.
    */
    # keep-sorted start group_start_regex=["^\\s*(?:\"[^\"]*\"|[a-zA-Z0-9_-]*)\\.url\\b"] newline_separated=yes
    denix.url = "github:yunfachi/denix/rewrite";
    denix.inputs.nixpkgs.follows = "nixpkgs";
    denix.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    # keep-sorted end

    /**
      Configuration Parts.

      External configuration components in separate repositories for confidentiality and reduced repository size.
    */
    # keep-sorted start group_start_regex=["^\\s*(?:\"[^\"]*\"|[a-zA-Z0-9_-]*)\\.url\\b"] newline_separated=yes
    # flake-secrets.url = "git+ssh://git@git.unnamed.systems/yunfachi/flake-secrets.git";
    flake-secrets.url = "/home/yunfachi/files/desktop/git/flake-secrets";
    # keep-sorted end

    /**
      Modules (system-wide, low-level).

      Low-level modules providing functionality used across the entire configuration.
    */
    # keep-sorted start group_start_regex=["^\\s*(?:\"[^\"]*\"|[a-zA-Z0-9_-]*)\\.url\\b"] newline_separated=yes
    disko-zfs.url = "github:numtide/disko-zfs";
    disko-zfs.inputs.nixpkgs.follows = "nixpkgs";
    disko-zfs.inputs.flake-parts.follows = "flake-parts";
    disko-zfs.inputs.disko.follows = "disko";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-secrets.url = "github:unnamed-systems/nix-secrets";
    nix-secrets.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";

    wrappers.url = "github:lassulus/wrappers";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    # keep-sorted end

    /**
      Modules (single-purpose, high-level).

      High-level modules providing feature-specific functionality for isolated modules.
    */
    # keep-sorted start group_start_regex=["^\\s*(?:\"[^\"]*\"|[a-zA-Z0-9_-]*)\\.url\\b"] newline_separated=yes
    helium.url = "github:oxcl/nix-flake-helium-browser";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    niri-nix.url = "git+https://codeberg.org/BANanaD3V/niri-nix";
    niri-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixowos.url = "github:yunfachi/nixowos";
    nixowos.inputs.nixpkgs.follows = "nixpkgs";
    nixowos.inputs.flake-parts.follows = "flake-parts";
    nixowos.inputs.denix.follows = "denix";

    nixsecauditor.url = "github:unnamed-systems/nixsecauditor";
    nixsecauditor.inputs.nixpkgs.follows = "nixpkgs";
    # keep-sorted end
  };

  /**
    Defining configuration logic in this section is prohibited.
    Instead, this section should be used to import configuration modules with context available only at this level.
  */
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
        /**
          Using `self.outPath` can lead to infinite recursion, especially in `imports`,
          because `self` represents the fully evaluated flake result.

          Therefore, a separate `root` argument is introduced instead.
        */
        specialArgs.root = ./.;
      }
      (
        { root, ... }:
        {
          imports = inputs.denix.lib.umport {
            path = root + "/flake";
          };
        }
      );
}

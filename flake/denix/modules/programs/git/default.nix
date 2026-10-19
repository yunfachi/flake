{
  delib,
  inputs,
  host,
  ...
}:
{
  denix.modules."programs.git" = { cfg, ... }: {
    options = with delib; {
      enable = boolOption host.cliFeatured;
      signing = {
        enable = boolOption (host.isDesktop && cfg.signingKey != null);
        key = allowNull (strOption null);
      };
    };

    nixos.ifEnabled = { pkgs, lib, ... }: {
      user.packages = [
        pkgs.git-lfs
        (inputs.wrappers.wrapperModules.git.apply {
          inherit pkgs;

          package = lib.mkForce pkgs.git;
          extraPackages = [ pkgs.git-lfs ];

          settings =
            lib.recursiveUpdate
              {
                user = {
                  name = "yunfachi";
                  email = "git@ynf.sh";
                };

                init.defaultBranch = "master";

                filter.lfs = {
                  clean = "git-lfs clean -- %f";
                  smudge = "git-lfs smudge -- %f";
                  process = "git-lfs filter-process";
                  required = true;
                };
              }
              (
                lib.optionalAttrs cfg.signing.enable {
                  user.signingKey =
                    assert cfg.signing.key != null;
                    cfg.signing.key;

                  commit.gpgSign = true;
                  tag.gpgSign = true;

                  gpg = {
                    format = "openpgp";
                    # TODO: uncomment after gpg module
                    # openpgp.program = lib.getExe myconfig.programs.gpg.package;
                  };
                }
              );
        }).wrapper
      ];
    };
  };
}

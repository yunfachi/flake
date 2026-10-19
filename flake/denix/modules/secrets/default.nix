{
  delib,
  inputs,
  host,
  lib,
  ...
}:
{
  denix.settings.hosts.extraSubmodules = [
    ({ config, ... }: {
      options.recipient =
        with delib;
        allowNull (strOption (inputs.flake-secrets.recipients.${config.name} or null));

      config.myconfig.always = {
        secrets.recipientAliases = {
          ${config.name} = lib.mkIf (config.recipient != null) [ config.recipient ];
          hosts = lib.mkIf (config.recipient != null) [ config.name ];
        };
      };
    })
  ];

  denix.modules."secrets" =
    { cfg, ... }:
    {
      options =
        with delib;
        let
          mkSecretSubmodule =
            {
              perHost ? false,
              hostName ? cfg.secrets.perHost.hostName,
            }:
            submodule (
              { config, ... }:
              {
                freeformType = attrs;

                options = {
                  name = strOption (lib.optionalString perHost "${hostName}/" + config._module.args.name);

                  neededForUsers = boolOption false;

                  path = pathOption "/run/nix-secrets${lib.optionalString config.neededForUsers "-for-users"}/secrets/${config.name}";

                  templateKey = strOption "{{NIX_SECRETS-${builtins.hashString "sha256" config.name}}}";
                  __toString = functionToOption str (self: self.templateKey);
                };
              }
            );

          mkTemplateSubmodule =
            {
              perHost ? false,
              hostName ? cfg.secrets.perHost.hostName,
            }:
            submodule (
              { config, ... }:
              {
                freeformType = attrs;
                imports = [ extraModule ];

                options = {
                  name = strOption (lib.optionalString perHost "${hostName}/" + config._module.args.name);

                  neededForUsers = boolOption false;

                  path = pathOption "/run/nix-secrets${lib.optionalString config.neededForUsers "-for-users"}/templates/${config.name}";
                };
              }
            );
        in
        {
          recipientAliases = attrsOfOption (coercedTo (either str (listOf str)) lib.toList (listOf str)) { };

          identityPath = pathOption "/var/lib/nix-secrets/key.txt";

          files = attrsOfOption (mkSecretSubmodule { });
          templates = attrsOfOption (mkTemplateSubmodule { });

          perHost = {
            hostName = strOption host.name;

            files = attrsOfOption (mkSecretSubmodule {
              perHost = true;
            });
            templates = attrsOfOption (mkTemplateSubmodule {
              perHost = true;
            });
          };
        };

      myconfig.always = {
        persist.files = [
          {
            file = cfg.identityPath;
            group = "root";
            user = "root";
            mode = "0600";
            inInitrd = true;
          }
        ];

        # secrets.recipientAliases.master =
      };

      nixos.always =
        { pkgs, ... }:
        let
          removeReadOnly = builtins.mapAttrs (
            _name: value:
            removeAttrs value [
              "templateKey"
              "__toString"
            ]
          );
          mergeWithPerHost =
            name:
            delib.strictMergeAttrs cfg.${name} (
              lib.mapAttrs' (_name: value: lib.nameValuePair value.name value) cfg.perHost.${name}
            );
        in
        {
          imports = [ inputs.nix-secrets.nixosModules.default ];

          systemd.services.nix-secrets-activate-before-users = {
            after = [
              "local-fs.target"
              "systemd-vconsole-setup.service"
            ];

            serviceConfig = {
              StandardInput = "tty";
              StandardOutput = "tty";
              StandardError = "tty";
              TTYPath = "/dev/tty1";

              ExecStartPre = pkgs.writeShellScript "input-nix-secrets-identity" ''
                (
                  IDENTITY_PATH=${lib.escapeShellArg cfg.identityPath}

                  mkdir -p ${lib.escapeShellArg (builtins.dirOf cfg.identityPath)}

                  if ! grep -q '[^[:space:]]' ${lib.escapeShellArg cfg.identityPath}; then
                    NIX_SECRETS_IDENTITY=$(systemd-ask-password --timeout=30 ${lib.escapeShellArg "Enter nix-secrets identity to write into ${cfg.identityPath}:"})

                    if [ -n "$NIX_SECRETS_IDENTITY" ]; then
                      (umask 0177 && printf '%s\n' "$NIX_SECRETS_IDENTITY" > "$IDENTITY_PATH")
                    else
                      echo "Input timed out or was empty. Skipping identity file creation. GL." >&2
                    fi
                  fi
                )
              '';
            };
          };

          security.nix-secrets = {
            enable = true;
            extraPackages = with pkgs; [ age ];

            storage = inputs.flake-secrets + "/storage";
            # TODO: change
            storagePath = "/home/yunfachi/files/desktop/git/flake-secrets/storage/";

            identityPaths = [ cfg.identityPath ];

            inherit (cfg) recipientAliases;

            secrets = removeReadOnly (mergeWithPerHost "files");
            templates = mergeWithPerHost "templates";
          };
        };
    };
}

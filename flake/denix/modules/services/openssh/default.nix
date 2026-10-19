{
  delib,
  ...
}:
{
  denix.modules."services.openssh" = { myconfig, ... }: {
    options = with delib; {
      enable = boolOption true;
    };

    nixos.ifEnabled = {
      # TODO: hardening + fail2ban
      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ myconfig.user.name ];
          MaxAuthTries = 3;
          PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
        };
      };
    };
  };
}

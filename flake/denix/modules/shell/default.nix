{
  delib,
  host,
  ...
}:
{
  denix.modules."shell" = {
    options = with delib; {
      enable = boolOption host.cliFeatured;
    };

    nixos.ifEnabled = { pkgs, ... }: {
      users.defaultUserShell = pkgs.bashInteractive;

      programs.bash = {
        enable = true;

        shellInit = ''
          printf "  |\\      _,,,---,,_
            /,\`.-'\`'    -.  ;-;;,_
            |,4-  ) )-,_..;\\ (  \`'-'
           '---'''(_/--'  \`-'\\_)
           
          Current time is \033[1;32m%(%H:%M:%S)T\033[0m
          " -1
        '';

        undistractMe = {
          enable = true;
          timeout = 15;
        };
      };
    };
  };
}

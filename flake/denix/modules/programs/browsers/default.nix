{
  delib,
  host,
  ...
}:
{
  denix.modules."programs.browsers" = {
    options = with delib; {
      enable = boolOption host.guiFeatured;
    };
  };
}

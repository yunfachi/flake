{ lib, ... }: {
  debug = true;

  systems = lib.systems.flakeExposed;
}

# { inputs, lib, ... }:
# {
#   denix.hosts."vps" =
#     { name, ... }:
#     let
#       secrets = inputs.flake-secrets.hosts.${name};
#     in
#     {
#       nixos.ifEnabled = {
#         networking = {
#           interfaces = {
#             eth0 = {
#               ipv4.addresses = lib.singleton {
#                 inherit (secrets.ipv4) address prefixLength;
#               };

#               ipv6.addresses = lib.singleton {
#                 inherit (secrets.ipv6) address prefixLength;
#               };
#             };
#           };

#           defaultGateway = {
#             address = secrets.ipv4.defaultGateway;
#             interface = "eth0";
#           };
#           defaultGateway6 = {
#             address = secrets.ipv6.defaultGateway;
#             interface = "eth0";
#           };
#         };
#       };
#     };
# }

{ }

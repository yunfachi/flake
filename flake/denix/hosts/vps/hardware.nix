{
  denix.hosts."vps" = {
    myconfig.ifEnabled = {
      disko.device = "/dev/vda";
      boot.mode = "uefi";
    };

    nixos.ifEnabled =
      { modulesPath, ... }:
      {
        networking.hostId = "2ec19280";

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.11";

        imports = [
          (modulesPath + "/profiles/qemu-guest.nix")
        ];

        boot = {
          initrd.availableKernelModules = [
            "ata_piix"
            "uhci_hcd"
            "virtio_pci"
            "sr_mod"
            "virtio_blk"
          ];

          zfs.forceImportRoot = true;
          zfs.devNodes = "/dev/disk/by-uuid";
        };
      };
  };
}

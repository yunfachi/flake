{
  denix.hosts."laptop" = {
    myconfig.ifEnabled = {
      disko.device = "/dev/nvme0n1";
      boot.mode = "uefi";
    };

    nixos.ifEnabled =
      {
        modulesPath,
        config,
        lib,
        ...
      }:
      {
        networking.hostId = "4d1374df";

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "26.11";

        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        boot = {
          initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [ "kvm-amd" ];
        };
      };
  };
}

{
  denix.hosts."pc" = {
    myconfig.ifEnabled = {
      disko.device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENF0WB26448L";
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
        networking.hostId = "e4e95b92";

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

{lib, ...}: {
  specialisation = {

    headless.configuration = {
      # dont sleep device on lid close
      services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
      };

      #### modules
      gnome.enable = lib.mkForce false;
      plasma.enable = lib.mkForce false;
      virtualization.enable = lib.mkForce true;
      devops.enable = true;
      steam.enable = lib.mkForce true;
      games.applications.enable = lib.mkForce true;
      thorium.enable = lib.mkForce true;
      rar.enable = true;
      wg-home.enable = lib.mkForce false;
      wg-home.local_ip = "10.10.1.3/32";
      wg-home.privateKeyFileLocation = "/home/user/.ssh/wg/zbook/priv.key";
      flatpak.enable = lib.mkForce false;
      storagefs.share.vega_nfs = lib.mkForce false;
      # storagefs.share.vega_smb = true;
      ide.vscode = lib.mkForce true;
      ide.zed.enable = lib.mkForce true;
      docker.enable = lib.mkForce true;
      podman.enable = lib.mkForce true;
      ####
      #
      device.woothing = lib.mkForce false;
      device.orbital-pathfinder = lib.mkForce false;
    };
  };
}

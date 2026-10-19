{ config, inputs, host, vars, lib, pkgs, ... }:
# Canon PIXMA MG4200 (USB) via github:bornav/cannonmg-4200-setup
# cnijfilter 3.80 binaries wrapped in proot; pstocanonij lands on cupsd's
# FilterPath via services.printing.drivers, so native (non-raw) print jobs
# from KDE/GTK apps work through the Canon PPD.
with lib;
{
  options = {
    device = {
      cannonmg-4200 = mkOption {
        type = types.bool;
        default = false;
        description = "Canon PIXMA MG4200 USB printer (cnijfilter 3.80 + proot)";
      };
    };
  };

  config = mkIf config.device.cannonmg-4200 {
    services.printing.enable = true;

    # adds lib/cups/filter/pstocanonij to cupsd's FilterPath; the Canon PPD
    # references the filter by bare name.
    services.printing.drivers = [
      inputs.cannonmg.packages.${host.system}.cups-driver
    ];

    hardware.printers.ensurePrinters = [
      {
        name = "mg4200";
        description = "Canon PIXMA MG4200 (USB)";
        location = "desk";
        # if the serial ever changes, find the new URI with: lpinfo -v
        deviceUri = "usb://Canon/MG4200%20series?serial=943468&interface=1";
        # driver name, not a path: cups-driverd resolves it relative to
        # share/cups/model/ in the merged cups bindir (services.printing.drivers
        # packages are linked there; cups-driver ships this PPD).
        model = "canonmg4200.ppd";
        ppdOptions.PageSize = "A4";
      }
    ];
    hardware.printers.ensureDefaultPrinter = "mg4200";
  };
}

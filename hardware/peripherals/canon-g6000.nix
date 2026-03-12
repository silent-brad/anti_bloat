{ config, pkgs, lib, ... }:

{
  services.printing.enable = true;

  hardware.printers = {
    ensurePrinters = [{
      name = "Canon_G6000";
      location = "Home";
      deviceUri =
        "dnssd://Canon%20G6000%20series._ipp._tcp.local/?uuid=00000000-0000-1000-8000-0018650ab629";
      model = "canong6000.ppd";
    }];
    ensureDefaultPrinter = "Canon_G6000";
  };
}

{inputs, host, ... }:
{
  environment.systemPackages = [
    inputs.winapps.packages."${host.system}".winapps
    inputs.winapps.packages."${host.system}".winapps-launcher # optional
  ];
}

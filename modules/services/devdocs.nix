{ config, pkgs, lib, ... }:

let
  docker = "${pkgs.docker}/bin/docker";
  image = "ghcr.io/freecodecamp/devdocs:latest";
  startScript = pkgs.writeShellScript "start-devdocs" ''
    ${docker} pull ${image} || true
    exec ${docker} run --rm --name devdocs -p 9292:9292 ${image}
  '';
in
{
  systemd.services.devdocs = {
    description = "devdocs";
    after = [ "network-online.target" "docker.service" ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      ExecStart = startScript;
      ExecStop = "${docker} stop devdocs";
      TimeoutStartSec = 300;
      TimeoutStopSec = 10;
    };
  };
}

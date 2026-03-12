{ config, pkgs, lib, ... }:

{
  systemd.services.devdocs = {
    description = "devdocs";
    after = [ "network.target" "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 10;
      WorkingDirectory = "/home/redironninja/devdocs";
      ExecStart = pkgs.writeShellScript "start-devdocs" ''
        #!/bin/sh
        ${pkgs.docker}/bin/docker build -t devdocs .
        ${pkgs.docker}/bin/docker rm -f devdocs || true
        exec ${pkgs.docker}/bin/docker run --name devdocs -p 9292:9292 devdocs
      '';
    };
  };
}

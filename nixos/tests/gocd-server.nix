# verifies:
#   1. GoCD server starts
#   2. GoCD server responds

import ./make-test.nix ({ pkgs, ...} : 

{
  name = "gocd-server";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ swarren83 ];
  };

  gocd_server =
    { config, pkgs, ... }:
    { services.gocd-server.enable = true;
    };

  testScript = ''
    $gocd_server->start;
    $gocd_server->waitForUnit("gocd-server");
    $gocd_server->succeed("curl -s -f localhost:8153");
  '';
})

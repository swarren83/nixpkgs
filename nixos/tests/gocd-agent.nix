# verifies:
#   1. GoCD agent starts
#   2. GoCD agent responds
#   3. GoCD agent is available on GoCD server using GoCD API
#     3.1. https://api.go.cd/current/#get-all-agents

import ./make-test.nix ({ pkgs, ...} : {
  name = "gocd-agent";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ swarren83 ];
  };

nodes = {
  gocd_agent =
    { config, pkgs, ... }:
    { 
      services.gocd-agent = {
        enable = true;
    };
};

  testScript = ''
    startAll;
    $gocd_agent->waitForUnit("gocd-agent");
    $gocd_agent->waitForUnit("gocd-server");
    $gocd_agent->succeed("curl -s -f localhost:8154/go/api/agents -H 'Accept: application/vnd.go.cd.v2+json'");
  '';
})

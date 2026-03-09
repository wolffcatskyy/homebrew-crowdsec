class CrowdsecUnifiBouncer < Formula
  desc "CrowdSec bouncer for UniFi Dream Machine (UDM/UDR) using native nftables"
  homepage "https://github.com/wolffcatskyy/crowdsec-unifi-bouncer"
  url "https://github.com/wolffcatskyy/crowdsec-unifi-bouncer/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e12752c6271c55908355396a2608ce5de1358f78a444ea4b23a873026076044f"
  license "MIT"

  depends_on "bash"
  depends_on "curl"
  depends_on "jq" => :recommended

  def install
    # Main scripts
    bin.install "setup.sh" => "crowdsec-unifi-bouncer-setup"
    bin.install "install.sh" => "crowdsec-unifi-bouncer-install"
    bin.install "bootstrap.sh" => "crowdsec-unifi-bouncer-bootstrap"
    bin.install "ensure-rules.sh" => "crowdsec-unifi-bouncer-ensure-rules"
    bin.install "detect-device.sh" => "crowdsec-unifi-bouncer-detect-device"
    bin.install "detect-sidecar.sh" => "crowdsec-unifi-bouncer-detect-sidecar"
    bin.install "metrics.sh" => "crowdsec-unifi-bouncer-metrics"
    bin.install "ipset-capacity-monitor.sh" => "crowdsec-unifi-bouncer-ipset-monitor"

    # Config examples
    (etc/"crowdsec-unifi-bouncer").install "crowdsec-firewall-bouncer.yaml.example"

    # Systemd service files (for reference)
    (share/"crowdsec-unifi-bouncer").install "crowdsec-firewall-bouncer.service"
    (share/"crowdsec-unifi-bouncer").install "crowdsec-unifi-metrics.service"

    # Grafana dashboard
    (share/"crowdsec-unifi-bouncer/grafana").install "grafana/crowdsec-unifi-bouncer-dashboard.json"
  end

  def caveats
    <<~EOS
      This bouncer is designed to run directly on UniFi Dream Machine devices
      (UDM SE, UDM Pro, UDR) using native nftables.

      To set up on your UniFi device, SSH in and run:
        crowdsec-unifi-bouncer-setup

      Example config has been installed to:
        #{etc}/crowdsec-unifi-bouncer/crowdsec-firewall-bouncer.yaml.example

      For the Docker sidecar deployment, see the README:
        https://github.com/wolffcatskyy/crowdsec-unifi-bouncer#sidecar-deployment
    EOS
  end

  test do
    assert_match "detect", shell_output("#{bin}/crowdsec-unifi-bouncer-detect-device 2>&1", 1)
  end
end

class ThermalGuard < Formula
  desc "Thermal safety net for Apple Silicon: freezes heavy jobs before the Mac cooks itself"
  homepage "https://github.com/pawelkwaczynski/thermal-guard"
  url "https://github.com/pawelkwaczynski/thermal-guard/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "37679dd2f0d25b5b0c2b17873409503eee9f90f685d1fc2c545cb521fac14d95"
  license "MIT"

  depends_on :macos
  depends_on "macmon"
  depends_on xcode: :build

  def install
    system "swiftc", "-O", "-o", "thermalstate", "thermalstate.swift"
    system "swiftc", "-O", "-o", "heatbar-bin", "heatbar.swift"
    bin.install "thermalstate"
    bin.install "heatbar-bin" => "heatbar"
    bin.install "guard.py" => "thermal-guard"
    bin.install "safe-run", "heat", "fleet", "thermal-report"
    pkgshare.install "install.sh", "uninstall.sh", "guard.py", "safe-run", "heat", "fleet",
                     "thermal-report", "thermalstate.swift", "heatbar.swift",
                     "pl.pawel.thermal-guard.plist", "pl.pawel.heatbar.plist", "branding",
                     "tests", "README.md"
  end

  def caveats
    <<~EOS
      To start the daemon and the menu bar (LaunchAgents, config, logos), run:
        bash #{pkgshare}/install.sh
      A fresh install starts in WATCH-ONLY mode - enable protection with one click
      in the menu bar. Uninstall everything with:
        bash #{pkgshare}/uninstall.sh
    EOS
  end

  test do
    assert_match "safe-run", shell_output("#{bin}/safe-run --help")
  end
end

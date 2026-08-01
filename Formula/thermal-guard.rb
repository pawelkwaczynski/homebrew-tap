# Author: Pawel Kwaczynski (FOCUS FRAME) <kwaczynski.pawel@gmail.com>
# Project of the AIrON student research club (Computer Science, AHE Lodz).
class ThermalGuard < Formula
  desc "Thermal safety net for Apple Silicon by Pawel Kwaczynski: freezes heavy jobs before the Mac cooks itself"
  homepage "https://github.com/pawelkwaczynski/coffee-paladin"
  url "https://github.com/pawelkwaczynski/coffee-paladin/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ef9e55720ed492f2a4b47128a32b55ff04107c195e9d73bce559ad2b28612963"
  license "MIT"

  depends_on :macos
  depends_on "macmon"
  depends_on xcode: :build

  def install
    # walidacja builda przy instalacji (natychmiastowy blad, gdy brak narzedzi Xcode);
    # artefakty odrzucamy - install.sh kompiluje per-uzytkownik i stawia LaunchAgents
    system "swiftc", "-O", "-o", "buildcheck_ts", "thermalstate.swift"
    system "swiftc", "-O", "-o", "buildcheck_hb", "heatbar.swift"
    rm "buildcheck_ts"
    rm "buildcheck_hb"
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      Finish the setup (daemon + menu bar LaunchAgents, config, logos):
        bash #{pkgshare}/install.sh
      A fresh install starts in WATCH-ONLY mode - enable protection with one
      click in the menu bar (the eye icon reminds you which mode you are in).
      Uninstall everything:  bash #{pkgshare}/uninstall.sh
    EOS
  end

  test do
    assert_match "safe-run", shell_output("python3 #{pkgshare}/safe-run --help")
  end
end

# Author: Pawel Kwaczynski (FOCUS FRAME) <kwaczynski.pawel@gmail.com>
# Project of the AIrON student research club (Computer Science, AHE Lodz).
class CoffeePaladin < Formula
  desc "Stops Mac overheating: pauses hot processes, keep-awake with thermal fuse"
  homepage "https://github.com/pawelkwaczynski/coffee-paladin"
  url "https://github.com/pawelkwaczynski/coffee-paladin/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "8bd10fc46a3546c7e0e8f7219f5afb77cb6a822115b92d7425f2f8b88307d8f8"
  license "MIT"

  depends_on xcode: :build
  depends_on "macmon"
  depends_on :macos

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

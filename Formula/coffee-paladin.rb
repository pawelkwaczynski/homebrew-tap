# Author: Pawel Kwaczynski (FOCUS FRAME) <kwaczynski.pawel@gmail.com>
# Project of the AIrON student research club (Computer Science, AHE Lodz).
class CoffeePaladin < Formula
  desc "Stops Mac overheating: pauses hot processes, keep-awake with thermal fuse"
  homepage "https://github.com/pawelkwaczynski/coffee-paladin"
  url "https://github.com/pawelkwaczynski/coffee-paladin/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "7b6e6b2dcda6a72dc3d6d75246996d40c5614a03ef0baee635a1e6b3b02d85b3"
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
      Needs Xcode command line tools for `swiftc` - WITHOUT THEM there is no menu
      bar app and no chip sensor, only the battery fuse:
        xcode-select --install

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

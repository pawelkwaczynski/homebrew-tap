# Author: Pawel Kwaczynski (FOCUS FRAME) <kwaczynski.pawel@gmail.com>
# Project of the AIrON student research club (Computer Science, AHE Lodz).
class CoffeePaladin < Formula
  desc "Stops Mac overheating: pauses hot processes, keep-awake with thermal fuse"
  homepage "https://github.com/pawelkwaczynski/coffee-paladin"
  url "https://github.com/pawelkwaczynski/coffee-paladin/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "25179eced0b8b46913c1d4f6f3798b432f5b7941d02cc9b9aa50b92b4287d7d8"
  license "MIT"

  depends_on "macmon"
  depends_on macos: :sonoma

  def install
    # walidacja builda przy instalacji (natychmiastowy blad, gdy brak narzedzi Xcode);
    # artefakty odrzucamy - install.sh kompiluje per-uzytkownik i stawia LaunchAgents
    system "swiftc", "-O", "-target", "arm64-apple-macosx14.0", "-o", "buildcheck_ts", "thermalstate.swift"
    system "swiftc", "-O", "-target", "arm64-apple-macosx14.0", "-o", "buildcheck_hb", "heatbar.swift"
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

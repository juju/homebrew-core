class Timidity < Formula
  desc "Software synthesizer"
  homepage "https://timidity.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2"
  sha256 "f97fb643f049e9c2e5ef5b034ea9eeb582f0175dce37bc5df843cc85090f6476"

  bottle do
    sha256 "5db392f0e53371e29fdca1ebeee3fdad24043f038c943314e991a06765d102a5" => :high_sierra
    sha256 "b45b1df69ab87563a77e1163114160f66679fde5548bac0ae81acb7fae86ab80" => :sierra
    sha256 "0b26a98c3e8e3706f8ff1fb2e21c014ac7245c01510799172e7f3ebdc71602ac" => :el_capitan
    sha256 "2bfaec5aaaacf7ed13148f437cbeba6bb793f9eacdab739b7202d151031253b4" => :yosemite
    sha256 "9e56e31b91c1cab53ebd7830114520233b02f7766f69f2e761d005b8bcd2fb58" => :mavericks
    sha256 "a6c27dd89a2a68505faa01a3be6b770d5c89ae79a9b4739a5f7f1d226bfedb2d" => :mountain_lion
  end

  option "without-darwin", "Build without Darwin CoreAudio support"
  option "without-freepats", "Build without the Freepats instrument patches from https://freepats.zenvoid.org/"

  depends_on "libogg" => :recommended
  depends_on "libvorbis" => :recommended
  depends_on "flac" => :recommended
  depends_on "speex" => :recommended
  depends_on "libao" => :recommended

  resource "freepats" do
    url "https://freepats.zenvoid.org/freepats-20060219.zip"
    sha256 "532048a5777aea717effabf19a35551d3fcc23b1ad6edd92f5de1d64600acd48"
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    formats = []
    formats << "darwin" if build.with? "darwin"
    formats << "vorbis" if build.with?("libogg") && build.with?("libvorbis")
    formats << "flac" if build.with? "flac"
    formats << "speex" if build.with? "speex"
    formats << "ao" if build.with? "libao"

    args << "--enable-audio=" + formats.join(",") if formats.any?

    system "./configure", *args
    system "make", "install"

    if build.with? "freepats"
      (share/"freepats").install resource("freepats")
      pkgshare.install_symlink share/"freepats/Tone_000",
                               share/"freepats/Drum_000",
                               share/"freepats/freepats.cfg" => "timidity.cfg"
    end
  end

  test do
    system "#{bin}/timidity"
  end
end

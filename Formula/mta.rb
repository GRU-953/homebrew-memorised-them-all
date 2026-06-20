class Mta < Formula
  desc "Local, token-free file digestion to knowledge-graph memory for Claude"
  homepage "https://github.com/GRU-953/memorised-them-all"
  url "https://github.com/GRU-953/memorised-them-all/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "351f737ebb9ba15bf7f3a43e8b936ad5e667c9977f301e6948b21e16d2a6764f"
  license "MIT"
  version "2.4.2"

  depends_on "python@3.12"
  depends_on "ollama" => :recommended
  depends_on "tesseract" => :recommended
  depends_on "ffmpeg" => :recommended

  def install
    libexec.install Dir["*"]
    (bin/"mta").write <<~SH
      #!/bin/bash
      export MTA_REPO="#{libexec}"
      exec /bin/bash "#{libexec}/scripts/mta-launcher.sh" "$@"
    SH
  end

  def caveats
    <<~EOS
      On first run, the mta command creates a self-managed virtualenv under
      ~/.memorised-them-all and installs its Python dependencies plus the latest
      MarkItDown from upstream (this needs network and may take a minute).

      For full local features, pull the open-source models:
        ollama pull qwen2.5:7b nomic-embed-text moondream
    EOS
  end

  test do
    assert_predicate bin/"mta", :exist?
    assert_match "mta-launcher", File.read(bin/"mta")
  end
end

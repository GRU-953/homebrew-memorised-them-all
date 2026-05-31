class Mta < Formula
  desc "Local, token-free file digestion to knowledge-graph memory for Claude"
  homepage "https://github.com/GRU-953/memorised-them-all"
  url "https://github.com/GRU-953/memorised-them-all/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4281cdfa2d3330239606d922757a3de1575d37f0af1270444d2fe00f9fb5cabd"
  license "MIT"
  version "1.2.0"

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

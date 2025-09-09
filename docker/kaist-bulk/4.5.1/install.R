install.packages("pak", repos = file.path("https://r-lib.github.io/p/pak/stable", .Platform$pkgType, R.Version()$os, R.Version()$arch))

packages <- c(
  "tidyverse",
  "plotly",
  "pheatmap",
  "patchwork",
  "clusterProfiler",
  "org.Hs.eg.db",
  "Rsubread",
  "rtracklayer",
  "SummarizedExperiment",
  "DESeq2",
  "edgeR",
  "tximport",
  "EnhancedVolcano",
  "WGCNA",
  "ggarchery",
  "IsoformSwitchAnalyzeR"
)
pak::pkg_install(packages, ask=FALSE)

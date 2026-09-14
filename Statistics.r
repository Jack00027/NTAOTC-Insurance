# Explore the Investment holdings in 2025-06-30

#install.packages("dplyr")
#install.packages("fst")
#install.packages("gt")  


library(gt)
library(fst)
library(dplyr)

df <- read.fst("data/raw/InvestmentHoldingsLatest2025-06-30.fst")

asset_types <- df |>
  count(STATASSETTYPE, sort = TRUE) |>
  mutate(share = n / sum(n),
         cum_share = cumsum(share))

tbl <- asset_types |>
  gt() |>
  tab_header(
    title = "Insurer holdings by statutory asset type",
    subtitle = "Period end 2025-06-30"
  ) |>
  cols_label(
    STATASSETTYPE = "Asset type",
    n = "Holdings",
    share = "Share",
    cum_share = "Cumulative"
  ) |>
  fmt_integer(n) |>                                  # 1,234,567
  fmt_percent(c(share, cum_share), decimals = 1) |>  # 12.3%
  sub_missing(missing_text = "Not reported") |>
  tab_source_note("Source: statutory investment holdings data.")

gtsave(tbl, "tables_figures/assets_by_type_2025-06-30.png")
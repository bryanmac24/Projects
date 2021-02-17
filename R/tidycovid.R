library(tidyverse)
library(tidycovid19)
install.packages("kableExtra")
library(kableExtra)
library(ggridges)
install.packages("stargazer")
library(stargazer)

df <- download_merged_data(cached = TRUE, silent = TRUE)
nobs <- df %>%
  group_by(iso3c) %>%
  summarise(
    nobs_hosp = sum(!is.na(hosp_patients)),
    nobs_icu = sum(!is.na(icu_patients)),
    nobs_vacc = sum(!is.na(total_vaccinations)),
    .groups = "drop"
  ) %>%
  filter(
    nobs_hosp != 0 | nobs_icu != 0 | nobs_vacc  != 0
  ) %>%
  arrange(iso3c)
kable(nobs) %>% kable_styling()
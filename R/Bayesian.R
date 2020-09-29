library(rvest)
library(readr)
library(dplyr)
library(ggplot2)
library(ggstatsplot)
library(BayesFactor)
male_100_html <- read_html("http://www.alltime-athletics.com/m_100ok.htm")
male_100_pres <- male_100_html %>%
  html_nodes(xpath = "//pre")
male_100_htext <- male_100_pres %>%
  html_text()
male_100_htext <- male_100_htext[[1]]
male_100 <- readr::read_fwf(male_100_htext, skip = 1, n_max = 3178,
                            col_types = cols(.default = col_character()),
                            col_positions = fwf_positions(
                              c(1, 16, 27, 35, 66, 74, 86, 93, 123),
                              c(15, 26, 34, 65, 73, 85, 92, 122, 132)
                            ))
male_100 <- male_100 %>%
  select(X2, X4) %>% 
  transmute(timing = X2, runner = X4) %>%
  mutate(timing = gsub("A", "", timing),
         timing = as.numeric(timing)) %>%
  filter(runner %in% c("Usain Bolt", "Asafa Powell", "Yohan Blake",
                       "Justin Gatlin", "Maurice Greene", "Tyson Gay")) %>%
  mutate_if(is.character, as.factor) %>%
  droplevels
male_100

male_100$runner <- forcats::fct_reorder(male_100$runner, male_100$timing)
male_100 %>%
  group_by(runner) %>%
  summarise(mean_timing = mean(timing)) %>%
  arrange(mean_timing)

male_100 %>%
  group_by(runner) %>%
  summarise(median_timing = median(timing)) %>%
  arrange(median_timing)

ggbetweenstats(data = male_100, 
               x = runner, 
               y = timing,
               type = "p",
               var.equal = FALSE,
               pairwise.comparisons = TRUE,
               partial = FALSE,
               effsize.type = "biased",
               point.jitter.height = 0, 
               title = "Parametric (Mean) testing assuming unequal variances",
               ggplot.component = ggplot2::scale_y_continuous(breaks = seq(9.6, 10.4, .2), 
                                                              limits = (c(9.6,10.4))),
               messages = FALSE
)

ggbetweenstats(data = male_100, 
               x = runner, 
               y = timing,
               type = "bf",
               var.equal = FALSE,
               pairwise.comparisons = TRUE,
               partial = FALSE,
               effsize.type = "biased",
               point.jitter.height = 0, 
               title = "Bayesian testing",
               messages = FALSE
)

compare_runners_bf <- function(df, runner1, runner2) {
  
  ds <- df %>%
    filter(runner %in% c(runner1, runner2)) %>%
    droplevels %>% 
    as.data.frame
  zzz <- ttestBF(formula = timing ~ runner, data = ds)
  yyy <- extractBF(zzz)
  xxx <- paste0("The evidence provided by the data corresponds to odds of ", 
                round(yyy$bf,0), 
                ":1 that ", 
                runner1, 
                " is faster than ",
                runner2 )
  return(xxx)
}

justtwo <- male_100 %>%
  filter(runner %in% c("Usain Bolt", "Asafa Powell")) %>%
  droplevels %>% 
  as.data.frame
t.test(formula = timing ~ runner, data = justtwo)

t.test(formula = timing ~ runner, data = justtwo, alternative = "less")

t.test(formula = timing ~ runner, data = justtwo, alternative = "less", mu = -0.038403)

justtwo <- male_100 %>%
  filter(runner %in% c("Usain Bolt", "Asafa Powell")) %>%
  droplevels %>% 
  as.data.frame
ttestBF(formula = timing ~ runner, data = justtwo, rscale = "medium")

ttestBF(formula = timing ~ runner, data = justtwo, rscale = "wide")

ttestBF(formula = timing ~ runner, data = justtwo, rscale = .2)

justtwo <- male_100 %>%
  filter(runner %in% c("Usain Bolt", "Asafa Powell")) %>%
  droplevels %>% 
  as.data.frame
# notice these two just return the same answer in a different order
ttestBF(formula = timing ~ runner, data = justtwo, nullInterval = c(0, Inf))

ttestBF(formula = timing ~ runner, data = justtwo, nullInterval = c(-Inf, 0))

justtwo <- male_100 %>%
  filter(runner %in% c("Usain Bolt", "Asafa Powell")) %>%
  droplevels %>% 
  as.data.frame
powellvbolt <- ttestBF(formula = timing ~ runner, data = justtwo, nullInterval = c(-Inf, 0))
powellvbolt[1]/powellvbolt[2]
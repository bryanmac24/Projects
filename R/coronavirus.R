devtools::install_github("RamiKrispin/coronavirus",force = TRUE)
library(coronavirus)
update_dataset()

library(plotly)
library(dplyr)
library(tidyr)

coronavirus<-coronavirus::coronavirus


# Scraped data from John Hopkins University.
data <- coronavirus %>%
  group_by(country,province,type, date) %>%
  summarise(total_cases = sum(cases)) %>%
  pivot_wider(names_from = type, values_from = total_cases) %>%
  arrange(date) %>%
  mutate(active = confirmed - death - recovered) %>%
  mutate(active_total = cumsum(active),
         recovered_total = cumsum(recovered),
         death_total = cumsum(death)) 


# Make the plot
data %>% filter(data$country == "US")
ggplot(data, aes(x=date, y=active_total)) +
  geom_line()

cor(data[4:10], use = "complete.obs")


# Extract the correlation coefficients
res2$r
# Extract p-values
res2$P

summary(lm(data$active~.,data))


data_what <- coronavirus %>%
  group_by(type, date) %>%
  summarise(total_cases = sum(cases)) %>%
  pivot_wider(names_from = type, values_from = total_cases) %>%
  arrange(date) %>%
  mutate(active = confirmed - death - recovered) %>%
  mutate(active_total = cumsum(active),
         recovered_total = cumsum(recovered),
         death_total = cumsum(death)) 


coronavirus %>% 
  group_by(type, date) %>%
  summarise(total_cases = sum(cases)) %>%
  pivot_wider(names_from = type, values_from = total_cases) %>%
  arrange(date) %>%
  mutate(active = confirmed - death - recovered) %>%
  mutate(active_total = cumsum(active),
         recovered_total = cumsum(recovered),
         death_total = cumsum(death)) %>%
  plot_ly(x = ~ date,
          y = ~ active_total,
          name = 'Active', 
          fillcolor = '#1f77b4',
          type = 'scatter',
          mode = 'none', 
          stackgroup = 'one') %>%
  add_trace(y = ~ death_total, 
            name = "Death",
            fillcolor = '#E41317') %>%
  add_trace(y = ~recovered_total, 
            name = 'Recovered', 
            fillcolor = 'forestgreen') %>%
  layout(title = "Distribution of Covid19 Cases Worldwide",
         legend = list(x = 0.1, y = 0.9),
         yaxis = list(title = "Number of Cases"),
         xaxis = list(title = "Source: Johns Hopkins University Center for Systems Science and Engineering"))


conf_df <- coronavirus %>% 
  filter(type == "confirmed") %>%
  group_by(country) %>%
  summarise(total_cases = sum(cases)) %>%
  arrange(-total_cases) %>%
  mutate(parents = "Confirmed") %>%
  ungroup() 

plot_ly(data = conf_df,
        type= "treemap",
        values = ~total_cases,
        labels= ~ country,
        parents=  ~parents,
        domain = list(column=0),
        name = "Confirmed",
        textinfo="label+value+percent parent")


df <- coronavirus::refresh_coronavirus_jhu()
library(dplyr)
library(tidyr)

df2 <- df %>% group_by(location,data_type, date) %>%
  summarise(total_cases = sum(value)) %>%
  pivot_wider(names_from = data_type, values_from = total_cases) %>%
  arrange(date) %>%
  mutate(active = cases_new - deaths_new - recovered_new) %>%
  mutate(active_total = cumsum(active),
         recovered_total = cumsum(recovered_new),
         death_total = cumsum(deaths_new)) %>%
  mutate(total_cases = active_total + death_total + recovered_total) %>%
  rename(cases = cases_new, deaths = deaths_new, recovered = recovered_new) %>%
  select(date,location,deaths,recovered,active,cases,death_total,recovered_total,active_total,total_cases)

library(ggplot2)
library(plotly)
ggplotly(ggplot(data=df2, aes(x=date, y=total_cases,group=location,color=location)) +
  geom_step() + theme(legend.position="none"))


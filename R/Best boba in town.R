client_id <- "kWUBjRWjovX-KBZK1knuCQ"
client_secret <- "n4G4m1iLRH3tBedVQoDr0Prg-XPhzbLPLzIh1uAT4BjvELAbclsibnZWixMrF4f9o5vRmlri6iMOg43CncS4ZE1ywvJaOcDtKLLo8ZKiwG1jasp2FsDt8EpNmc1yX3Yx"

res <- POST("https://api.yelp.com/oauth2/token",
            body = list(grant_type = "client_credentials",
                        client_id = client_id,
                        client_secret = client_secret))

token <- content(res)$access_token

yelp <- "https://api.yelp.com"
term <- "boba"
location <- "Westminster, CA"
categories <- NULL
limit <- 50
radius <- 8800
url <- modify_url(yelp, path = c("v3", "businesses", "search"),
                  query = list(term = term, location = location, 
                               limit = limit,
                               radius = radius))
res <- GET(url, add_headers('Authorization' = paste("bearer", client_secret)))

results <- content(res)

yelp_httr_parse <- function(x) {
  
  parse_list <- list(id = x$id, 
                     name = x$name, 
                     rating = x$rating, 
                     review_count = x$review_count, 
                     latitude = x$coordinates$latitude, 
                     longitude = x$coordinates$longitude, 
                     address1 = x$location$address1, 
                     city = x$location$city, 
                     state = x$location$state, 
                     distance = x$distance)
  
  parse_list <- lapply(parse_list, FUN = function(x) ifelse(is.null(x), "", x))
  
  df <- data_frame(id=parse_list$id,
                   name=parse_list$name, 
                   rating = parse_list$rating, 
                   review_count = parse_list$review_count, 
                   latitude=parse_list$latitude, 
                   longitude = parse_list$longitude, 
                   address1 = parse_list$address1, 
                   city = parse_list$city, 
                   state = parse_list$state, 
                   distance= parse_list$distance)
  df
}

results_list <- lapply(results$businesses, FUN = yelp_httr_parse)

business_data <- do.call("rbind", results_list)


ggplot(business_data, aes(rating, review_count, colour = rating)) + geom_jitter(aes(color = rating))

ggplot(business_data, aes(x=rating)) + 
  geom_density() + 
  theme(legend.position="none") + 
  xlab("Rating") + 
  ggtitle("Ratings Density") + 
  geom_vline(aes(xintercept=mean(rating)), color="blue", linetype="dashed", size=1)

# Map
library(leaflet)

mymap<-leaflet::leaflet() %>% 
  addTiles() %>% 
  addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png")  %>%  
  mapOptions(zoomToLimits="always") %>%             
  addMarkers(lat=business_data$latitude,lng=business_data$longitude,
             clusterOptions = markerClusterOptions(),popup=business_data$id) 

mymap

most4StarsReviews = business_data %>%
  filter(rating >= 4) %>%
  group_by(name) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  ungroup() %>%
  mutate(BusinessID = reorder(name,Count))
most4StarsReviews

most4StarsReviews %>%
  mutate(name = reorder(name,Count)) %>%
  ggplot(aes(x = name,y = Count)) +
  geom_bar(stat='identity',colour="white", fill = 'blue') +
  labs(x = 'Name of the Business', 
       y = 'Count', 
       title = 'Name of the Businesses that have 5 stars') +
  coord_flip() +
  theme_bw()

library(ggplot2)
# Barplot
ggplot(business_data, aes(x = rating, y = review_count, fill = rating)) + geom_col()

georoute( c("3817 Spruce St, Philadelphia, PA 19104", 
            "9000 Rockville Pike, Bethesda, Maryland 20892"), 
          verbose=TRUE, returntype="time", 
          service="bing" )

install.packages("gmapsdistance")
library(gmapsdistance)

gmapsdistance(origin = "33.780980+-118.055180",
              destination = "33.78717+-117.9591",
              mode = "driving",
              key = "AIzaSyBpMGKAApG1IqYP8CaubTngeov37hNJJ8A") 

gmapsdistance(origin,destination,combinations = "all",mode,key = get.api.key(),shape = "wide",avoid = "",departure = "now",dep_date = "",dep_time = "",traffic_model = "None",arrival = "",arr_date = "",arr_time = "")

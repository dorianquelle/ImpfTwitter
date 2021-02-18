library(twitteR)
library(tidyverse)
library(rvest)

#Set up Twitter API-Tokens 
consumerKey <- "JPPKToCHmmzFFoCSSFanB1KOI"
consumerSecret <- "3su6Bwz4xD2nrBK3hoagj5fhB2Cq10E9ExRqj6hnCkVUwIaTfs"
accessToken <-  "1357301412892463113-UyKJsdXdnSQIFGXaj6TCaIwW7ETUbh"
accessTokenSecret <- "4e61HVsE7YBRMiQfalyvYlhrG0E8y9tXRK9rFtWBdFbpK"
setup_twitter_oauth(consumer_key = consumerKey,consumer_secret = consumerSecret,access_token = accessToken,access_secret = accessTokenSecret)

#Scrape the german impfdashboard
ht <- read_html("https://impfdashboard.de/")
dat <- ht %>% html_nodes(".svelte-aidjyy") %>% html_text()

#Calculate the values
heute_geimpft <- dat[3] %>% gsub(.,pattern = "\\.",replacement = "") %>% as.numeric()
insgesamt <- dat[4] %>% gsub(.,pattern = "\\.",replacement = "") %>% as.numeric()
#tage <- ((0.67*(83020000-insgesamt)*1.894)/heute_geimpft) %>% floor
tage <- ((0.67*(83020000-insgesamt)*1.894)/(insgesamt/as.numeric(Sys.Date()-as.Date("2020-12-27")))) %>% floor
end_tag <- Sys.Date()+tage
überdauer <- as.numeric(end_tag-as.Date("2021-09-21"))

#Post message
message <- paste("Gestern wurden",heute_geimpft,"Menschen geimpft. Im aktuellen Tempo sind 2/3. der Bevölkerung am",end_tag,"geimpft.", überdauer, "Tage nach dem 21.Sept")
tweet(message)


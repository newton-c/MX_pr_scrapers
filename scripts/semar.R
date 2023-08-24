library(tidyverse)
library(rvest)

# SEMAR
# Kind of working, should be up with a bit more elbow grease

url <- "https://www.gob.mx/semar/archivo/prensa?idiom=es"

semar_url <- read_html(url)

semar_links <- semar_url %>%
  html_elements("article") %>%
  html_elements("a") %>%
  html_attr("href") %>%
  unlist()

get_semar_articles <- function(i) {
  
}

temp_url <- read_html(paste0("https://www.gob.mx", semar_links[1]))

temp_title <- temp_url %>%
  html_element("h1") %>%
  html_text()

temp_location_date <- temp_url %>%
  html_element("strong") %>%
  html_text()

temp_location <- sub(" a [0-9].*$", "", temp_location_date)
temp_date <- str_extract(temp_location_date, "[0-9]+ de [a-z]+ de [0-9]+") 

temp_body <- temp_url %>%
  html_elements("p") %>%
  html_text2() %>%
  unlist

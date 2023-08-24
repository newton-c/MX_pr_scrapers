library(tidyverse)
library(rvest)

# SEDENA

url <- "https://www.gob.mx/sedena/#7679"

agarrar_vinculos <- read_html(url)
buscar_vinculos <- agarrar_vinculos %>%
  html_element("body") %>%
 # html_element("main") %>%
  html_elements("section") %>%
 # html_nodes("section") %>%
  html_elements(".press")
  html_attrs("href")
  html_element(".press") %>%
  html_elements("h4") %>%
   %>%
 

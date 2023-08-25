library(tidyverse)
library(rvest)

# FGR
fgr_url <- "https://www.gob.mx/fgr/archivo/prensa?idiom=es"

agarrar_html <- read_html(fgr_url)

agarrar_vinculos <- agarrar_html %>%
  html_elements("article") %>%
  html_elements("a") %>%
  html_attr("href") %>%
  unlist

agarrar_vinculos <- ifelse(grepl("page", agarrar_vinculos) == FALSE,
                           agarrar_vinculos, NA) %>%
  sub("\\\\\"", "", .)
  
agarrar_vinculos <- agarrar_vinculos[!is.na(agarrar_vinculos)]


agarrar_notas <- function(i) {
  temp_url <- paste0("https://www.gob.mx", agarrar_vinculos[i])
  temp_html <- read_html(temp_url)
  
  temp_titulo <- temp_html %>% 
    html_element("h1") %>% 
    html_text()
  
  temp_lugar <- temp_html %>%
    html_element("h2") %>%
    html_text()
  
  temp_fecha <- temp_html %>%
    html_element("dl") %>%
    html_elements("dd") %>%
    html_text
  temp_fecha <-temp_fecha[2]
  
  temp_texto <- temp_html %>%
    html_element(".article-body") %>% 
    html_text()
  
  temp_datos <- tibble(title = temp_titulo,
                       link = temp_url,
                       date = temp_fecha,
                       location = temp_lugar,
                       text = temp_texto)
}


crear_conjuto <- map_df(seq_len(length(agarrar_vinculos)), agarrar_notas)

file_name <- paste0("data/FGR_", Sys.Date(), ".csv") 
write_excel_csv(crear_conjuto, file_name)

library(tidyverse)
library(rvest)

# FGR
fgr_url <- "https://www.gob.mx/fgr/archivo/prensa?idiom=es"

agarrar_html <- read_html(fgr_url)

agarrar_vinculos <- agarrar_html %>%
  html_element("body") %>%
  html_elements(".small-link") %>%
  html_attr("href") %>%
  unlist

agarrar_fechas <- agarrar_html %>%
  html_elements("time") %>%
  html_attr("datetime")

volver_datos <- tibble(título = NA, lugar = NA, texto = NA, url = NA)
agarrar_notas <- function(i) {
  temp_url <- paste0("https://www.gob.mx", agarrar_vinculos[i])
  temp_html <- read_html(temp_url)
  
  temp_titulo <- temp_html %>% 
    html_element("h1") %>% 
    html_text()
  
  temp_lugar <- temp_html %>%
    html_element("h2") %>%
    html_text()
  
#  temp_fecha <- temp_html %>%
#    html_element("dl") %>%
#    html_elements("dd") %>%
#    html_text
#  temp_fecha <- parse_date(temp_fecha[2],
#                           "%d de %B de %Y",
#                           locale = locale("es"))
#  
  temp_texto <- temp_html %>%
    html_element(".article-body") %>% 
    html_text()
  
  temp_datos <- tibble(temp_titulo, temp_lugar, temp_texto, temp_url)
  colnames(temp_datos) <- c("título", "lugar", "texto", "url")
  volver_datos <- full_join(volver_datos, temp_datos) %>%
    remove_missing

  return(volver_datos)
}


crear_conjuto <- map_df(seq_len(length(agarrar_vinculos)), agarrar_notas)
write_excel_csv(crear_conjuto, "data/starting_data.csv")


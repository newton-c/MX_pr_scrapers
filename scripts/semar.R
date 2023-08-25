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
  temp_url <- paste0("https://www.gob.mx", semar_links[i])
  temp_html <- read_html(temp_url)
  
  temp_title <- temp_html %>%
    html_element("h1") %>%
    html_text()
  
  temp_location_date <- temp_html %>%
    html_element("strong") %>%
    html_text()
  
  temp_location <- sub(" a [0-9].*$", "", temp_location_date)
  temp_date <- str_extract(temp_location_date, "[0-9]+ de [a-z]+") 
  
  temp_body <- temp_html %>%
    html_elements("p") %>%
    html_text2() 
  
  temp_body <- temp_body[temp_body != temp_body[1:2]]
  
  temp_body <- temp_body %>%
    paste(unlist(.), collapse='') 
  
  temp_tibble <- tibble(title = temp_title,
                        link = temp_url,
                        location = temp_location,
                        date = temp_date,
                        body = temp_body,
                        test = NA)
}

run_scraper <- map_df(seq_along(semar_links), get_semar_articles)

file_name <- paste0("data/SEMAR_", Sys.Date(), ".csv") 

write_excel_csv(run_scraper, file_name)

cmd <- paste("curl --max-time 7200 --connect-timeout 7200 --ntlm --user",
             "cnewton:A@4$6R9EUTRBKH", 
             "--upload-file SEMAR_2023-08-25.csv",
             "https://fundacionic.sharepoint.com/:x:/r/sites/ICData/_layouts/15/Doc.aspx?sourcedoc=%7B085B80FA-C7AA-4E75-8FAA-B14630375E35%7D&file=SEMAR_2023-08-25.csv&action=default&mobileredirect=true",
             sep = " ")
system(cmd)

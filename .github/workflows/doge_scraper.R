library(RSelenium)
library(rvest)
library(purrr)
driver <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444,
  browserName = "chrome"
)
driver$open()
driver$navigate("https://doge.gov/savings")
button <- driver$findElement(using = "xpath", value = "/html/body/div/main/div/div/div[5]/div[2]/div/div/button")
button$click() 
Sys.sleep(3)
page_source <- driver$getPageSource()[[1]]
page <- LinkExtractor(page_source, ExternalLInks = TRUE)
fpds <- page$ExternalLinks
links_df <- data.frame(links = fpds)
write.csv(links_df, "scraped_links.csv", row.names = FALSE)
driver$close()

library(purrr)
library(RSelenium)
library(rvest)

url <- "https://doge.gov/savings"
driver <- rsDriver(browser = "chrome")
remote_driver <- driver[["client"]]

# Navigate to the webpage
remote_driver$navigate(url)

# Simulate scrolling to reveal hidden content (if needed)
button <- remote_driver$findElement(using = "xpath", value = "/html/body/div/main/div/div/div[5]/div[2]/div/div/button")
button$click()

# You can simulate more scrolls or interactions here if necessary.
Sys.sleep(3)  # Wait for content to load

# Get the page source after scrolling
page_source <- remote_driver$getPageSource()[[1]]
if (is.null(page_source) || nchar(page_source) == 0) {
  stop("Error: Page source is empty or NULL.")
}

# Extract links from the page source
page <- LinkExtractor(page_source, ExternalLInks = TRUE)
fpds <- page$ExternalLinks

# Save links to a CSV file
links_df <- data.frame(links = fpds)
write.csv(links_df, 'scraped_links.csv', row.names = FALSE)

# Close the driver
driver$close()

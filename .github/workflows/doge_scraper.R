library(purrr)
library(RSelenium)
library(rvest)

# Start the remote driver
driver <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444,
  browserName = "chrome"
)
driver$open()

# Navigate to the page
driver$navigate("https://doge.gov/savings")

# Wait for a specific element (button) to ensure page has loaded
button <- driver$findElement(using = "xpath", value = "//*[@id="main-content"]/div/div/div[5]/div[2]/div/div/button")
button$click()

# Wait for the page to load
Sys.sleep(5)

# Check if page source is valid
page_source <- driver$getPageSource()[[1]]
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

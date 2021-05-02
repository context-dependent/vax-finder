pacman::p_load(
  "tidyverse",
  "RSelenium",
  "rvest",
  "httr"
)

source("R/02-site-data.R")


test_nygh_url_ref <- "https://nygh.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day=2021-04-27T00:00:00.000-04:00&location_id=SCV&slot_type=OLDER&key=fba9f065-ebb8-4412-baaf-73534eb37854"

pjs_test <- wdman::phantomjs(port = 4444L)
driver <- rsDriver(browser = 'phantomjs', port = 4444L)

pacman::p_load(
  "tidyverse",
  "httr",
  "rvest",
  "lubridate"
)

test_url <- "https://camh.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day=2021-04-25T04:00:00.000Z&location_id=CMH&slot_type=CONDITIONS&key=e9ae7abf-1c88-479b-9c1a-2e81a21da988"


x <- GET(test_url)

m <- html_session(test_url)



# Notes

# - getting 403 error with just the url
# - need to set session cookies, unsure of where to get them from
# - spoofed user agent seems to actually do the trick.
# - any way to scrape the dropdowns?
# - CAMH slot types:
#   * CONDITIONS - Mental health conditions, substance abuse, etc.
#   * Patient - Health care workers
#   * INDIGENOUS - Indigenous (first nations, inuit, metis)
#   * LEADERS - Faith Leaders
#   * CONGREGATE - High-risk individuals living in congregate settings
#   * HOTSPOT - adults 50+ in hotspots

url_cookie_source <- "https://www.camh.ca//en/camh-news-and-stories/covid-19-vaccine-booking"

m2 <- html_session(url_cookie_source)

url_camh_iframe <- "https://camh.vertoengage.com/engage/?key=e9ae7abf-1c88-479b-9c1a-2e81a21da988"
user_agent_common <- user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36")

m3 <- html_session(url_camh_iframe, user_agent_common)

cookies_camh_iframe <- cookies(m3) %>% as_tibble()

m4 <- html_session(test_url, user_agent_common)

test_response <- content(m4$response)

test_response

m4$response %>% content()

build_camh_url <- function(day, location_id, slot_type, key) {

  glue::glue(
    "https://camh.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day={day}T04:00:00.000Z&location_id={location_id}&slot_type={slot_type}&key={key}"
  )

}


test_url_rebuild <- build_camh_url(
  day = "2021-04-25",
  location_id = "CMH",
  slot_type = "CONDITIONS",
  key = "e9ae7abf-1c88-479b-9c1a-2e81a21da988"
)


m5 <- html_session(test_url_rebuild, user_agent_common)
m5$response %>% content()

scrape_slots_one <- function(url) {
  x <- html_session(url, user_agent_common)
  status <- x$response$status_code
  if(status != 200) {
    return(NA)
  }
  res <- content(x$response)$slots_left
  res
}

scrape_slots <- function(url) {
  res <- url %>%
    map_dbl(~scrape_slots_one(.x))

  res
}

dat_bare_grid <- expand_grid(
  day = seq.Date(today(), today() + 7, by = "1 day"),
  slot_type = c(
    "Patient",
    "CONDITIONS",
    "INDIGENOUS",
    "LEADERS",
    "CONGREGATE",
    "HOTSPOT"
  ),
  location_id = "CMH",
  key = "e9ae7abf-1c88-479b-9c1a-2e81a21da988"
)

dat_camh_example <- dat_bare_grid %>%

  mutate(
    url = build_camh_url(day, location_id, slot_type, key),
    slots = scrape_slots(url),
    any_slots = case_when(
      slots > 0 ~ "Slots Available",
      slots == 0 ~ "No Slots",
      TRUE ~ NA_character_
    ) %>%

      fct_expand(
        "Slots Available",
        "No Slots"
      )
  )


build_verto_url <- function(provider_tag, day, location_id, slot_type, key) {

  glue::glue(
    "https://{provider_tag}.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day={day}T04:00:00.000Z&location_id={location_id}&slot_type={slot_type}&key={key}"
  )

}

source("R/02-site-data.R")

generate_param_grid <- function(provider_data) {

  f <- function(x) {
    expand_grid(
      day = seq.Date(today(), today() + 7, by = "1 day"),
      !!!x
    )
  }

  res <- provider_data %>%
    map(f) %>%
    bind_rows()

  res
}


param_grid <- generate_param_grid(provider_data)

dat_slots <- param_grid %>%

  mutate(
    url = build_verto_url(
      provider_tag, day, location_id, slot_type, key
    ),
    slots = scrape_slots(url),
    any_slots = case_when(
      slots > 0 ~ "Slots Available",
      slots == 0 ~ "No Slots",
      TRUE ~ NA_character_
    ) %>%

      fct_expand(
        "Slots Available",
        "No Slots"
      )
  )


# Notes

# - nygh and mwtoth not working.
#   * test different timestamp

test_nygh_url <- "https://nygh.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day=2021-05-01T04:00:00.000Z&location_id=NCV&slot_type=CHRONIC&key=fba9f065-ebb8-4412-baaf-73534eb37854"

m_nygh <- html_session(test_nygh_url, user_agent_common)


test_nygh_url_ts <- "https://nygh.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day=2021-04-25T00:00:00.000-04:00&location_id=NCV&slot_type=CHRONIC&key=fba9f065-ebb8-4412-baaf-73534eb37854"

m_nygh_ts <- html_session(test_nygh_url_ts, user_agent_common)

test_nygh_url_ref <- "https://nygh.vertoengage.com/engage/api/api/cac-open-clinic/v1/slots/availability?day=2021-04-26T00:00:00.000-04:00&location_id=SCV&slot_type=OLDER&key=fba9f065-ebb8-4412-baaf-73534eb37854"

m_nygh_ref <- html_session(test_nygh_url_ref, user_agent_common, timeout(5))

m_test_orig <- html_session(test_url, user_agent_common)


# test hrbrmstr/cfhttr - No good, doesn't recognize it as a cf protected site

# remotes::install_github("hrbrmstr/cfhttr")


library(cfhttr)

cf_GET(test_nygh_url_ref)


# test scraper API

# Example url
"http://api.scraperapi.com/?api_key=0a87f5fcc77579a81c2d66a1086b0351&url=http://httpbin.org/anything&keep_headers=true"


# URL set up

build_scraper_api_url <- function(target_url) {

  res <- glue::glue("http://api.scraperapi.com/?api_key=0a87f5fcc77579a81c2d66a1086b0351&url={target_url}&render=true&keep_headers=true")

  res
}


test_scraper_api_url <- build_scraper_api_url(test_nygh_url_ref)


m_nygh_scraper_test <- html_session(test_scraper_api_url, user_agent_common)

m_nygh_scraper_test_get


library(RSelenium)


driver <- rsDriver(browser = "chrome", chromever = "90.0.4430.24", port = 4446L)

driver$client$open()

driver$client$navigate(test_nygh_url_ref)

driver$client$getAllCookies()

non_api_test_url_mwtoht <- "https://mwtoht-ymca.vertoengage.com/engage/generic-open-clinic?key=9518d7a7-27c9-49a1-ac49-f523bfcbbfe4&__cf_chl_jschl_tk__=ef0c7c52bb13b0464a4231069dd3d863c524f6d8-1619377255-0-AQ9c3aW-Z_jn_TfnREbNYkQBvOQwnCI4RAYUvKxtpyztLOfrxWtjAy8WnZzEbUBc1_JDJjy0uH_BzvwNsWBsNLhBuqz_hR9n0ycT8bEsnvWcj0RQw-vgvjkSE5obqCikoSGLraoNrgmyTH0Epp50nloeqQs7pwso1Vhz1fBtBIwgphWfI-Byb32dBBpR2TKmTDya3yD-_bOUkQFxMzuVZgdwbRwO6xwI-juYdhIHz_VyOiqXLM7-rfQVO8uNYkcYQPQAbbQTAScwEHM6NdoJdFxnXcVFLbjxu8Wq6odAojV6O_AD9Rha7KqUz0C_d3wAI0M_PaOldfUcBrHaAuugl9pEHAyEtv8NWoVAVUHmQU6wuBbXG2Vsl177w_e1M8TwWR3_sZVN8fNz96CD1vq0lyWF1BrKYvsz07WUQMAwcaEyVLWOgBkapk_2_WOEoixD78sH5mI78npgUK7CsWc16hwjE43UDY2BHBRE-QMVZbxdGMXK0MKDDdDYqbJqgM155OboD-DnnVmbvSulrf3Da6cs2R7L9WDhBPRN4K1Gcczr"

driver$client$close()
driver$client$open()
driver$client$navigate(non_api_test_url_mwtoht)

test_scraper_api_url

driver_phantom <- rsDriver(browser = "phantomjs", port = 4448L)

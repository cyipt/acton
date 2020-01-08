#' Get data from Planit API
#'
#' @param bbox
#' @param base_url
#' @param limit
#' @param end_date
#' @param start_date
#' @param silent
#'
#' @return
#' @export
#'
#' @examples
get_planit_data = function(bbox,
                          base_url = "https://www.planit.org.uk/api/applics/json",
                          limit = 30,
                          end_date = "2009-02-01",
                          start_date = "2000-02-01",
                          silent = FALSE) {

  u = get_planit_url(bbox, base_url = "https://www.planit.org.uk/api/applics/json",
                                limit = 30,
                                end_date = "2009-02-01",
                                start_date = "2000-02-01")

  if(!silent) {
    message("Getting data from ", u)
  }
  res = jsonlite::fromJSON(u)
  res$records
}


# key parameters

# convert to function
bbox_to_string = function(bbox) {
  paste(bbox, collapse = ",")
}


get_planit_url = function(bbox,
                          base_url = "https://www.planit.org.uk/api/applics/json",
                          limit = 30,
                          end_date = "2009-02-01",
                          start_date = "2000-02-01") {
  bbox_char = bbox_to_string(bbox)
  query = list(limit = limit, bbox = bbox_char, end_date = end_date, start_date = start_date)
  httr::modify_url(url = base_url, query = query)
}





# tests while developing - to delete --------------------------------------

# bbox = c(-1.366023, 53.744171, -1.35515, 53.747495)
# paste(bbox, collapse = "%2C") # works!

# # res = sf::read_sf("https://www.planit.org.uk/api/applics/json?limit=30&bbox=-1.366023%2C53.744171%2C-1.35515%2C53.747495&end_date=2009-02-01&start_date=2000-02-01") # failed
# res = jsonlite::fromJSON("https://www.planit.org.uk/api/applics/json?limit=30&bbox=-1.366023%2C53.744171%2C-1.35515%2C53.747495&end_date=2009-02-01&start_date=2000-02-01")
# # awesome it worked!
# class(res$records) # it gives us a data frame
# bbox_char = bbox_to_string(bbox)
# bbox_char == "-1.366023%2C53.744171%2C-1.35515%2C53.747495"
# get_planit_url(bbox = bbox)
# test_url = get_planit_url(bbox = bbox)
# test_url == "https://www.planit.org.uk/api/applics/json?limit=30&bbox=-1.366023%2C53.744171%2C-1.35515%2C53.747495&end_date=2009-02-01&start_date=2000-02-01"
# "https://www.planit.org.uk/api/applics/json?limit=30&bbox=-1.366023%2C53.744171%2C-1.35515%2C53.747495&end_date=2009-02-01&start_date=2000-02-01"
# test_url == "https://www.planit.org.uk/api/applics/json?limit=30&bbox=-1.366023%2C53.744171%2C-1.35515%2C53.747495&end_date=2009-02-01&start_date=2000-02-01"
# get_planit_data(bbox)

#' Get data from Planit API
#'
#' @param bbox Bounding box in the form of xmin, ymin, xmax, ymax, e.g.: `c(-1.3, 53.7, -1.2, 53.9)`
#' @param base_url The base URL of the service
#' @param limit How many items to return (e.g. 6, default)
#' @param end_date E.g. `"2009-02-01"`
#' @param start_date E.g. `"2000-02-01"`
#' @param silent Do you want a message? Default is `FALSE`
#'
#' @return A data frame
#' @export
#'
#' @examples
#' get_planit_data(bbox = c(-1.366023, 53.744171, -1.35515, 53.747495))
get_planit_data = function(bbox,
                          base_url = "https://www.planit.org.uk/api/applics/json",
                          limit = 6,
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

#' Convert bbox to string
#' @inheritParams get_planit_data
bbox_to_string = function(bbox) {
  paste(bbox, collapse = ",")
}

#' Get url of planit API key
#' @inheritParams get_planit_data
get_planit_url = function(bbox,
                          base_url = "https://www.planit.org.uk/api/applics/json",
                          limit = 30,
                          end_date = "2009-02-01",
                          start_date = "2000-02-01") {
  bbox_char = bbox_to_string(bbox)
  query = list(limit = limit, bbox = bbox_char, end_date = end_date, start_date = start_date)
  httr::modify_url(url = base_url, query = query)
}

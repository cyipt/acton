#' Get data from Planit API
#'
#' This function requests data from [planit.org.uk](https://www.planit.org.uk).
#' See their [API spec](https://www.planit.org.uk/api/) and their
#' [data dictionary](https://www.planit.org.uk/dictionary/)
#' for further information.
#'
#' @param bbox Bounding box in the form of xmin, ymin, xmax, ymax, e.g.: `c(-1.3, 53.7, -1.2, 53.9)`
#' @param query_type The type of query (`"applics"` by default)
#' @param query_type_search Text string associated with the `query_type` (may be updated)
#' @param fmt The format of the output (`"geojson"` returns an `sf` object, `"json"` returns a data frame)
#' @param base_url The base URL of the service
#' @param limit How many items to return (e.g. 6, default)
#' @param end_date E.g. `"2009-02-01"`. Default is `as.character(Sys.Date())`.
#' @param start_date The earliest application (date of application) to be filtered `"2000-02-01"`
#' @param pcode Postcode = UK postcode to use for the centre of a location search
#' @param krad Radius (km) = only planning applications within the circle perimeter are returned (default 2)
#' @param silent Do you want a message? Default is `FALSE`
#'
#' @return A (geographic) data frame
#' @export
#'
#' @examples
#' bbox = c(-1.4, 53.7, -1.3, 53.8)
#' res = get_planit_data(bbox) # return geographic (`sf`) object
#' class(res)
#' plot(res)
#' get_planit_data(bbox, fmt = "json", limit = 2) # return data frame with limit
#' get_planit_data(bbox, end_date = "2008-01-01", limit = 2) # historic data
#' get_planit_data(bbox, pcode = "LS2 9JT", limit = 2) # data from specific postcode
get_planit_data = function(bbox,
                          query_type = "applics",
                          query_type_search = NULL,
                          fmt = "geojson",
                          base_url = "https://www.planit.org.uk/api",
                          limit = 6,
                          end_date = as.character(Sys.Date()),
                          start_date = "2000-02-01",
                          pcode = NULL,
                          krad = NULL,
                          silent = FALSE
                          ) {

  if(is.null(query_type_search)) {
    base_url_updated = paste(base_url, query_type, fmt, sep = "/")
  } else {
    base_url_updated = paste(base_url, query_type, query_type_search, fmt, sep = "/")
  }

  bbox_char = bbox_to_string(bbox)

    query = list(
    limit = limit,
    bbox = bbox_char,
    end_date = end_date,
    start_date = start_date,
    # ensure all results are on one page, I think (RL)
    pg_sz = limit,
    pcode = pcode,
    krad = krad
  )
  u = httr::modify_url(url = base_url_updated, query = query)


  if(!silent) {
    message("Getting data from ", u)
  }
  if(fmt == "json") {
    res = jsonlite::fromJSON(u)$records
  } else {
    res = sf::read_sf(u)
  }
  res
}

#' Convert bbox to string
#' @inheritParams get_planit_data
bbox_to_string = function(bbox) {
  paste(bbox, collapse = ",")
}

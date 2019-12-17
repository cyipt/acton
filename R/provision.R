#' Estimate walkability
#'
#' @param osm_network sf object of highways from OSM
#' @param parameters Weightings given to different columns (some of which could be calculated)
#' @param walking_potential_weights Optional variable to weight the measure by estimated number of trips on different segments (by scenario)
#'
#' @return
#' @export
#'
#' @examples
estimate_walkability = function(osm_network, parameters = c(hilliness = 1.3, directness = 1.8), walking_potential_weights = NULL) {
  message("Calculating walking potential...")
  Sys.sleep(2)
  message("Aha, the answer is 42")
  return(42)
}

x = c(1, 2, 4)
x_character = "Hello world"

x

x_combined = paste(x, x_character)
x_combined

x_df = data.frame(
  x,
  x_combined
)
x_df

library(acton)
developments_manchester = get_planit_data(auth = "Manchester")
mapview::mapview(developments_manchester)

developments_large = get_planit_data(limit = 500, app_size = "large")
mapview::mapview(developments_large)





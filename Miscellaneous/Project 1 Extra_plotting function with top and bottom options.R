# Function we want to create
plot.county <- function(df, var_name = "enrollment", filter_state = "AL", filter_county = "top", filter_value = 5) {
  
  filter_multiplier <- ifelse(filter_county == "top", 1,
                              ifelse(filter_county == "bottom", 0, -1))
  
  new_df <- df %>%
    filter(state == filter_state) %>%
    group_by(area_name) %>%
    summarise(avg_enrollment = mean(get(var_name))) %>%
    arrange(ifelse(filter_multiplier * avg_enrollment > 0, desc(avg_enrollment),
                   ifelse(filter_multiplier * avg_enrollment > -1, avg_enrollment, 
                          stop("Must select either 'top' or 'bottom' as options for filter_county; default is 'top'")))) %>%
    slice(1:filter_value)
  
  filtered_df <- df %>%
    filter((state == filter_state) & (area_name %in% new_df$area_name))
  
  ggplot(filtered_df, aes(x = year, y = get(var_name), color = area_name)) + 
    geom_line()
}

# Puts things in order from top to bottom, even without argument
plot(data_combine[["county"]], filter_state = "NC", filter_value = 10)

# Puts things in order from top to bottom
plot(data_combine[["county"]], filter_state = "NC", filter_county = "top", filter_value = 10)

# Puts things in order from bottom to top
plot(data_combine[["county"]], filter_state = "NC", filter_county = "bottom", filter_value = 10)

# Will stop the function; invalid argument and prints warning message
plot(data_combine[["county"]], filter_state = "NC", filter_county = "I don't care", filter_value = 10)

# Convert values to 0.5 to 1

conv_half_1 <- function(x){
  rx = max(x)-min(x)
  incrx <- 0.5/rx
  y <- 0.5 + (x-min(x))*incrx
  return(y)
}

# Convert data for simplest clock chart
# This will be used to convert data for showing times on clock.
# Length of hands of clock is constant

conv_data <- function(data, time){
  # Data Preparation
  dt <- data %>%
    mutate(time = hms::parse_hm({{ time }})) %>%
    tidyr::separate_wider_delim(cols = {{ time }},
                                names = c("hr", "mn", "sc"),
                                cols_remove = FALSE,
                                delim = ":") %>% # Separate minute
    dplyr::mutate(mn = as.numeric(ifelse(is.na(.data$mn),0,.data$mn)),
                  mn = .data$mn/60,
                  #minute = ifelse(.data$minute<10, .data$minute * 5/30, .data$minute * 5/300),
                  hr = as.numeric(.data$hr),
                  timc = .data$hr+.data$mn,
                  time_angle = ifelse(0<=.data$timc & .data$timc<=6,
                                      (6-.data$timc)*pi/12,
                                      (30-.data$timc)*pi/12),
                  x1 = cos(.data$time_angle)*0.97,
                  y1 = sin(.data$time_angle)*0.97,
                  x0 = rep(0, dim(data)[1]),
                  y0 = rep(0, dim(data)[1]))
  return(dt)
}

#  Convert data for coloring based on criteria, without modifying length.

conv_data_col <- function(data, time, colby){
  # Data Preparation
  dt <- data %>%
    mutate(time = hms::parse_hm({{ time }})) %>%
    tidyr::separate_wider_delim(cols = {{ time }},
                                names = c("hr", "mn", "sc"),
                                cols_remove = FALSE,
                                delim = ":") %>% # Separate minute
    mutate(mn = as.numeric(ifelse(is.na(.data$mn),0,.data$mn)),
           mn = .data$mn/60,
           #minute = ifelse(.data$minute<10, .data$minute * 5/30, .data$minute * 5/300),
           hr = as.numeric(.data$hr),
           timc = .data$hr+.data$mn, # Ignore second
           time_angle = ifelse(0<=.data$timc & .data$timc<=6,
                               (6-.data$timc)*pi/12,
                               (30-.data$timc)*pi/12),
           x1 = cos(.data$time_angle)*0.95,
           y1 = sin(.data$time_angle)*0.95,
           x0 = rep(0, dim(data)[1]),
           y0 = rep(0, dim(data)[1]),
           colby = {{ colby }})
  return(dt)
}


# Change length of hands by a quantitative vector, optionally select a
# color for the hands
conv_data_len <- function(data, time, len){
  len <- dplyr::pull(data, {{ len }})
  # Normalize length. This will be replace by rn
  len <- (len-min(len))/(max(len)-min(len))
  len[which(len==0)] = (
    min(len)+min(len[len!=min(len)]))/2
  len[which(len==1)] = (
    max(len)+max(len[len!=max(len)]))/2
  rn <- conv_half_1(len)

  # Data Preparation
  dt <- data %>%
    dplyr::mutate(len = rn,
                  time = hms::parse_hm({{ time }})) %>%
    tidyr::separate_wider_delim(cols = {{ time }},
                         names = c("hr", "mn", "sc"),
                         cols_remove = FALSE,
                         delim = ":") %>% # Separate minute
    dplyr::mutate(mn = as.numeric(ifelse(is.na(.data$mn),0,.data$mn)),
                  mn = .data$mn/60,
           #minute = ifelse(.data$minute<10, .data$minute * 5/30, .data$minute * 5/300),
           hr = as.numeric(.data$hr),
           timc = .data$hr+.data$mn,
           time_angle = ifelse(0<=.data$timc & .data$timc<=6,
                               (6-.data$timc)*pi/12,
                               (30-.data$timc)*pi/12),
           x1 = cos(.data$time_angle)*rn*0.95,
           y1 = sin(.data$time_angle)*rn*0.95,
           x0 = rep(0, dim(data)[1]),
           y0 = rep(0, dim(data)[1]))
  return(dt)
}


# Keep factor original order

keep_fct_order <- function(x) factor(x, levels = unique(x))

## Legend lines
# ---
# -----
# --------

lgl <- data.frame(x0 = rep(1.1, 3),
                  x1 = c(1.2, 1.3, 1.4),
                  y0 = c(-0.1, 0, 0.1),
                  y1 = c(-0.1, 0, 0.1))

# geom_segment(data = lgl, mapping = aes(x=x0, y = y0, xend = x1, yend = y1))

library(reshape2)
library(ggplot2)

dat <- read.table(text = "A   B   C
1 48 780 431
2 720 350 377
3 460 480 179
4 220 240 876", header = TRUE)


dat$row <- seq_len(nrow(dat))
dat2 <- melt(dat, id.vars = "row")


ggplot(dat2, aes(x = variable, y = value, fill = row)) + 
  geom_bar(stat = "identity") +
  xlab("\nType") +
  ylab("Time\n") +
  coord_flip() +
  theme_bw()



test  <- data.frame(person=c("A", "B", "C", "D", "E"), 
                    value1=c(100,150,120,80,150),     
                    value2=c(25,30,45,30,30) , 
                    value3=c(100,120,150,150,200)) 
melted <- melt(test, "person")

melted$cat <- ''
melted[melted$variable == 'value1',]$cat <- "local"
melted[melted$variable != 'value1',]$cat <- "remote"

ggplot(melted, aes(x = cat, y = value, fill = variable)) + 
  geom_bar(stat = 'identity', position = 'stack') + facet_grid(~ person)




library(ggplot2)
library(dplyr)

# Set up the data
metrics <- c('Capturing/Processing Time', 'Encoding/Decoding Time', 'Transmission Time', 'Network Latency', 'Rendering FPS')
values <- list(c(45, 5, 50, 53, 80), c(60, 15, 60, 80, 65), c(75, 22, 71, 120, 59))

# Set up custom sorting order
custom_order <- c('Capturing/Processing Time', 
                  'Encoding/Decoding Time', 
                  'Transmission Time', 
                  'Network Latency',
                  'Rendering FPS')

# Create a data frame
data <- data.frame(metric = factor(rep(metrics, 3), levels = custom_order),
                   value = unlist(values),
                   test = rep(c("C1", "C2", "C3"), each = length(metrics)))

# Create the chart
ggplot(data, aes(x = value, y = metric, fill = test)) +
  geom_col(position = position_dodge(width = .65), width = .45) +
  scale_y_discrete(expand = c(0, 1)) +
  scale_fill_manual(values = c("#3c3c3c", "#666666", "#B5B5B5")) +
  labs(title = "System Performance Chart", x = "Time in ms or FPS", y = "System Performance Metrics") +
  theme_minimal() +
  theme(axis.line = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())



# Save the chart as a PDF file
ggsave("out/performance.pdf", width = 10, height = 7, unit = "in", dpi = 300)




# Load required libraries
library(ggplot2)
library(dplyr)
library(lubridate)

# Generate sample data
set.seed(42)
sample_size <- 1000
timestamps <- seq(from = as.POSIXct("2023-01-01 00:00:00"), by = "10 min", length.out = sample_size)
latencies <- runif(sample_size, min = 10, max = 500)

data <- data.frame(timestamp = timestamps, latency = latencies)

# Convert the timestamp column to a proper date-time format
data$timestamp <- as.POSIXct(data$timestamp, format="%Y-%m-%d %H:%M:%S")

# Calculate the average, minimum, and maximum latency per time period (e.g., per hour)
latency_summary_data <- data %>%
  group_by(time_period = floor_date(timestamp, "hour")) %>%
  summarise(avg_latency = mean(latency, na.rm = TRUE),
            min_latency = min(latency, na.rm = TRUE),
            max_latency = max(latency, na.rm = TRUE))

# Create the combined latency chart using ggplot2
ggplot() +
  geom_linerange(data = latency_summary_data, aes(x = time_period, ymin = min_latency, ymax = max_latency), color = "gray", alpha = 0.5) +
  geom_line(data = latency_summary_data, aes(x = time_period, y = avg_latency), color = "blue") +
  geom_point(data = latency_summary_data, aes(x = time_period, y = avg_latency), color = "blue") +
  labs(title = "End-to-End Latency",
       x = "Time Period",
       y = "Latency (ms)") +
  theme_minimal()


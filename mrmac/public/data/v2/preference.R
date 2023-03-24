library(ggplot2)
library(dplyr)

coloring = c("#E76469", "#F8D85E","#EDA645","#E76469","#8C99A6","#ADD299","#4FA490","#3B7F9F")
coloring1 = c("", "","","","")
fontsize = 14
data=read.csv('csv/preference.csv', sep=",")

p <- ggplot(data, aes(x = conditions, y = score, fill = factor(rank))) + 
  geom_bar(stat = 'identity', position = 'stack') + 
  coord_flip() +
  theme_bw()

# Add labels to bars
p <- p + geom_text(aes(label = score), position = position_stack(vjust = 0.5), color = "black", size = 4)

# Add facet grid
p <- p + facet_grid(rows = vars(qus), switch = "y") + 
  theme(strip.placement = "outside",
        strip.background = element_rect(fill=coloring[3], color = NA))

# Apply the custom colors to the fill color of each factor level
p <- p + scale_fill_manual(values = coloring)

# Add theme elements
p <- p + theme(axis.title.x=element_blank(),
               axis.title.y = element_blank(), 
               plot.margin = unit(c(0, 0, .5, 0), "null"),
               panel.border = element_blank(),
               legend.title=element_blank(),
               legend.direction="horizontal",
               legend.position = c(.5,-.05),
               legend.justification = c("center", "top"))

# Show the plot
p

# Add custom text labels to bars for each facet
label_data <- data.frame(qus = unique(data$qus), label = c("Label 1", "Label 2", "Label 3"))
p <- p + geom_text(data = label_data, aes(x = Inf, y = Inf, label = label), hjust = 1, vjust = 1, size = 6)

data_text <- data.frame(label = c("*", "", "**", "", ""), 
                        qus = names(table(data$qus)),
                        x = c(1.6, 0, 0.6, 0, 0),
                        y = c(36.6, 0, 36.6, 0, 0),
                        x1 = c(3, 0, 2, 0,0), 
                        x2 = c(2, 0, 1,0, 0), 
                        y1 = c(36, 0, 36, 0, 0), 
                        y2 = c(36.5, 0, 36.5, 0, 0))
p +
  geom_text(data = data_text, aes(x = x, y = y, label = label, fill=coloring1), angle = -90, position = position_nudge(0.9)) +
  geom_segment(data = data_text, aes(x = x1, xend = x1, y = y1, yend = y2, fill=coloring1), colour = "black") +
  geom_segment(data = data_text, aes(x = x2, xend = x2, y = y1, yend = y2, fill=coloring1), colour = "black") +
  geom_segment(data = data_text, aes(x = x1, xend = x2, y = y2, yend = y2, fill=coloring1), colour = "black")


# saving the final figure
ggsave("out/preference.pdf", width = 7, height = 4, dpi = 1000)
write.csv(data_text,'csv/pref-signif.csv')




# Create a sample data frame
df <- data.frame(x = 1:10, y = rnorm(10), group = rep(letters[1:2], each = 5))

# Create a facet grid chart with two panels
p <- ggplot(df, aes(x, y)) +
  geom_point() +
  facet_grid(. ~ group)

# Add a line to the first panel of the facet grid chart
p <- p +
  geom_segment(aes(x = 3, y = -2, xend = 7, yend = -2), 
               size = 2, color = "red",
               data = subset(df, group == "a"))

# Display the chart
p































library(ggplot2)

data=read.csv('csv/preference.csv', sep=",")

coloring <- c("red", "green", "blue", "orange", "purple")
coloring1 <- c("red", "green", "blue", "orange", "purple")

p <- ggplot(data, aes(x = conditions, y = score, fill = factor(rank))) + 
  geom_bar(stat = 'identity', position = 'stack') + 
  coord_flip() +
  theme_bw()

# Add labels to bars
p <- p + geom_text(aes(label = score), position = position_stack(vjust = 0.5), color = "black", size = 4)

# Add facet grid
p <- p + facet_grid(rows = vars(qus), switch = "y") + 
  theme(strip.placement = "outside",
        strip.background = element_rect(fill=coloring[3], color = NA))

# Apply the custom colors to the fill color of each factor level
p <- p + scale_fill_manual(values = coloring)

# Add theme elements
p <- p + theme(axis.title.x=element_blank(),
               axis.title.y = element_blank(), 
               plot.margin = unit(c(0, 0, .5, 0), "null"),
               panel.border = element_blank(),
               legend.title=element_blank(),
               legend.direction="horizontal",
               legend.position = c(.5,-.05),
               legend.justification = c("center", "top"))

# Create separate geom_text layers for asterisks for each question
geom_text_asterisk_q1 <- geom_text(data = subset(data, qus == "q1"), aes(label = "*"), x = "C1", y = max(data$score) + 5, color = "black", size = 6)
geom_text_asterisk_q1_c2 <- geom_text(data = subset(data, qus == "q1"), aes(label = "*"), x = "C2", y = max(data$score) + 5, color = "black", size = 6)
geom_text_asterisk_q2 <- geom_text(data = subset(data, qus == "q2"), aes(label = "**"), x = "C1", y = max(data$score) + 5, color = "black", size = 6)
geom_text_asterisk_q3 <- geom_text(data = subset(data, qus == "q3"), aes(label = "*"), x = "C1", y = max(data$score) + 5, color = "black", size = 6)
geom_text_asterisk_q4 <- geom_text(data = subset(data, qus == "q4"), aes(label = "***"), x = "C1", y = max(data$score) + 5, color = "black", size = 6)


# Create separate geom_text layers for asterisks for each question and condition
create_asterisk_geom <- function(q, c, y_offset) {
  geom_text(data = subset(data, qus == q), aes(label = "*"), x = c, y = max(data$score[data$conditions == c & data$qus == q]) + y_offset, color = "black", size = 6)
}

# Create a function to generate geom_segment layers for each question and condition combination
create_segment_geom <- function(q, c1, c2) {
  data_subset <- subset(data, qus == q)
  y1 <- max(data_subset$score[data_subset$conditions == c1])
  y2 <- max(data_subset$score[data_subset$conditions == c2])
  
  geom_segment(aes(x = c1, xend = c2, y = y1, yend = y2), color = "black", linetype = "dashed")
}

conditions <- unique(data$conditions)
questions <- unique(data$qus)
y_offset <- 5

asterisk_geoms <- lapply(questions, function(q) {
  lapply(conditions, function(c) {
    create_asterisk_geom(q, c, y_offset)
  })
})




# Create the ggplot object without the original geom_text
p <- ggplot(data, aes(x = conditions, y = score, fill = factor(rank))) + 
  geom_bar(stat = 'identity', position = 'stack') + 
  coord_flip() +
  theme_bw()

# Add the separate geom_text layers for asterisks for each question
p <- p + geom_text_asterisk_q1 + geom_text_asterisk_q1_c2 + geom_text_asterisk_q2 + geom_text_asterisk_q3 + geom_text_asterisk_q4

# Add the separate geom_text layers for asterisks for each question and condition
for (q in asterisk_geoms) {
  for (g in q) {
    p <- p + g
  }
}

# Add the separate geom_segment layers for each question and condition combination
for (q in questions) {
  for (i in 1:(length(conditions) - 1)) {
    for (j in (i + 1):length(conditions)) {
      p <- p + create_segment_geom(q, conditions[i], conditions[j])
    }
  }
}

# Continue with the rest of your code
p <- p + facet_grid(rows = vars(qus), switch = "y") + 
  theme(strip.placement = "outside",
        strip.background = element_rect(fill=coloring[3], color = NA))

p <- p + scale_fill_manual(values = coloring)

p <- p + theme(axis.title.x=element_blank(),
               axis.title.y = element_blank(), 
               plot.margin = unit(c(0, 0, .5, 0), "null"),
               panel.border = element_blank(),
               legend.title=element_blank(),
               legend.direction="horizontal",
               legend.position = c(.5,-.05),
               legend.justification = c("center", "top"))
p

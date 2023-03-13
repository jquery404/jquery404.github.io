library(ggplot2)
library(dplyr)


preferences <- data.frame(
  Condition = c("H1", "H2", "H3", "H4"),
  R1 = c(2, 4, 1, 3), # Change these values to match the actual rankings in the study
  R2 = c(4, 3, 2, 1), # Change these values to match the actual rankings in the study
  R3 = c(3, 2, 4, 1), # Change these values to match the actual rankings in the study
  R4 = c(1, 2, 3, 4) # Change these values to match the actual rankings in the study
)

# Load ggplot2 library
library(ggplot2)

# Create example data
data <- data.frame(Category = c("H1", "H2", "H3"),
                   `Rank 1` = c(20, 30, 50),
                   `Rank 2` = c(30, 50, 20),
                   `Rank 3` = c(50, 20, 30))

# Convert data from wide to long format
data_long <- tidyr::gather(data, "Group", "Value", -Category)

# Create stacked bar chart
ggplot(data_long, aes(x = Category, y = Value, fill = Group)) +
  geom_bar(stat = "identity", position = "fill") +
  geom_text(aes(label = Value, group = Group), position = position_fill(vjust = 0.9), hjust = 1) +
  geom_signif(comparisons = list(c("H2", "H1"),
                                 c("H2", "H3"),
                                 c("H3", "H1")),
              test = "wilcox.test", step_increase = 0.075, y_position= .05) +
  coord_flip() +
  labs(title = "Horizontal Stacked Bar Chart", x = "Category", y = "Percentage")









#create data frame
df <- data.frame(team=rep(c('A', 'B', 'C'), each=3),
                 position=rep(c('Guard', 'Forward', 'Center'), times=3),
                 points=c(3, 2, 1, 1, 3, 2, 1, 2, 3))

ggplot(df, aes(fill=position, y=points, x=team)) + 
  geom_bar(position='stack', stat='identity') + 
  geom_signif(comparisons = list(c("B", "A"),
                                 c("B", "C"),
                                 c("C", "A")),
              test = "wilcox.test", step_increase = 0.15, y_position= 6.1) +
  
  ylim(0, 7) +
  coord_flip()


ggplot(df, aes(fill=position, y=points, x=team)) + 
  geom_bar(position='stack', stat='identity') + 
  geom_signif(comparisons = list(c("B", "A"),
                                 c("B", "C"),
                                 c("C", "A")),
              test = "t.test", step_increase = 0.075) 








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





library(ggplot2)
library(dplyr)

# Using the iris dataset
data(iris)

# Discretize the Petal.Length variable to create bins
iris$Petal.Length.Bin <- cut(iris$Petal.Length, breaks = seq(1, 7, by = 1), include.lowest = TRUE)

# Calculate the mean Sepal.Length for each combination of Species and Petal.Length.Bin
mean_sepal_lengths <- iris %>%
  group_by(Species, Petal.Length.Bin) %>%
  summarise(Sepal.Length = mean(Sepal.Length), .groups = "drop")
# Sort by the Species and Petal.Length.Bin columns
mean_sepal_lengths_sorted <- mean_sepal_lengths %>%
  arrange(Species, rev(Petal.Length.Bin))

# Get the cumulative sum
mean_sepal_lengths_sorted <- mean_sepal_lengths_sorted %>%
  group_by(Species) %>%
  mutate(label_y = cumsum(Sepal.Length))

# Create the bar plot
plot <- ggplot(mean_sepal_lengths_sorted, aes(x = Species, y = Sepal.Length, fill = Petal.Length.Bin)) +
  geom_col() +
  geom_text(aes(y = label_y, label = round(Sepal.Length, 1)), vjust = 1.5, colour = "white") +
  labs(title = "Mean Sepal Length by Species and Petal Length Bin",
       x = "Species",
       y = "Mean Sepal Length") +
  theme_minimal()

# Display the plot
print(plot)

write.csv(mean_sepal_lengths_sorted, file = "out/mean_sepal_lengths_sorted.csv", row.names = FALSE)




library(ggplot2)
library(dplyr)

data=read.csv('csv/mean_sepal_lengths_sorted.csv', sep=",")
# Add a sorting variable to the data frame
data <- data %>%
  mutate(Sorting = case_when(
    Qus == "q1" & Species == "versicolor" ~ 1,
    Qus == "q1" & Species == "setosa" ~ 2,
    Qus == "q2" & Species == "setosa" ~ 3,
    Qus == "q2" & Species == "versicolor" ~ 4
  ))


# Create the bar plot
plot <- ggplot(data, aes(x = Species, y = Sepal.Length, fill = Petal.Length.Bin)) +
  geom_col() +
  geom_text(aes(y = label_y, label = round(Sepal.Length, 1)), vjust = 1.5, colour = "white") +
  labs(title = "Mean Sepal Length by Species and Petal Length Bin",
       x = "Species",
       y = "Mean Sepal Length") +
  theme_minimal()

# Display the plot
print(plot)

# Sort by the Qus and Species columns
data_sorted <- data %>%
  arrange(Qus, rev(Species))



# Create the bar plot
plot <- ggplot(data, aes(x = interaction(Qus, Species, sep = " - "), y = Sepal.Length, fill = Petal.Length.Bin)) +
  geom_col() +
  geom_text(aes(y = label_y, label = round(Sepal.Length, 1)), vjust = 1.5, colour = "white") +
  labs(title = "Sepal Length by Qus, Species and Petal Length Bin",
       x = "Qus and Species",
       y = "Sepal Length") +
  theme_minimal()

# Display the plot
print(plot)




library(reshape2)
# Create the new data frame
data <- data.frame(
  qus = c("q1", "q1", "q1", "q2", "q2", "q2", "q3", "q3", "q3", "q4", "q4", "q4", "q5", "q5", "q5"),
  conditions = c("C1", "C2", "C3", "C1", "C2", "C3", "C1", "C2", "C3", "C1", "C2", "C3", "C1", "C2", "C3"),
  rank1 = c(4, 6, 23, 10, 8, 23, 2, 13, 28, 10, 10, 24, 1, 10, 29),
  rank2 = c(10, 23, 10, 17, 20, 8, 9, 21, 6, 8, 25, 7, 16, 22, 5),
  rank3 = c(22, 7, 3, 9, 8, 5, 25, 2, 2, 18, 1, 5, 19, 4, 2)
)
# Add a sorting variable to the data frame
data1 <- data %>%
  mutate(Sorting = interaction(qus, conditions, sep = ""))

data_melted <- melt(data1, id.vars = c("qus", "conditions", "Sorting"), variable.name = "rank", value.name = "value")

# Create the bar plot
plot <- ggplot(data_melted, aes(x = factor(Sorting, labels = c("q1C1", "q1C2", "q1C3", "q2C1", "q2C2", "q2C3", "q3C1", "q3C2", "q3C3", "q4C1", "q4C2", "q4C3", "q5C1", "q5C2", "q5C3")), y = value, fill = rank)) +
  geom_col() +
  facet_wrap(~ qus) +
  geom_text(aes(label = value), position = position_stack(vjust = 0.5), colour = "white") +  # Center the text
  coord_flip() +  # Flip the plot
  scale_fill_manual(values = c("rank1" = "#595959", "rank2" = "#C1C1C1", "rank3" = "#343434")) +  # Custom colors
  labs(x = "Qus and Conditions",
       y = "Value") +
  theme_minimal()

# Display the plot
print(plot)



stat.test <- data_melted %>% 
  group_by(rank) %>% 
  wilcox_test(value~conditions, p.adjust.method = 'BH') %>%
  add_significance("p") %>%
  add_xy_position(x = "rank")

plot +
stat_pvalue_manual(stat.test, label = 'p.signif', hide.ns = TRUE, tip.length = 0.02)


# Create the long format data frame
long_data <- data1 %>%
  gather(key = "rank", value = "value", -c(qus, conditions, Sorting))
# Perform a one-way ANOVA
anova_results <- aov(value ~ conditions, data = long_data)
summary(anova_results)
# Perform Tukey's HSD post-hoc test
tukey_results <- TukeyHSD(anova_results)
tukey_results

stat.test <- long_data %>% 
  group_by(params) %>% 
  wilcox_test(score~conditions, p.adjust.method = 'BH') %>%
  add_significance("p") %>%
  add_xy_position(x = "params")

# saving the final figure
ggsave("out/preference.pdf", width = 7, height = 3.5, dpi = 1000)





# Create the new data frame
library(ggplot2)
library(reshape2)
library(dplyr)

data <- data.frame(
  qus = c("q1", "q1", "q1", "q2", "q2", "q2", "q3", "q3", "q3", "q4", "q4", "q4", "q5", "q5", "q5"),
  conditions = c("C1", "C2", "C3", "C1", "C2", "C3", "C1", "C2", "C3", "C1", "C2", "C3", "C1", "C2", "C3"),
  rank1 = c(4, 6, 23, 10, 8, 23, 2, 13, 28, 10, 10, 24, 1, 10, 29),
  rank2 = c(10, 23, 10, 17, 20, 8, 9, 21, 6, 8, 25, 7, 16, 22, 5),
  rank3 = c(22, 7, 3, 9, 8, 5, 25, 2, 2, 18, 1, 5, 19, 4, 2)
)

data1 <- data %>%
  mutate(Sorting = interaction(factor(qus), conditions, sep = ""))

data_melted <- melt(data1, id.vars = c("qus", "conditions", "Sorting"), variable.name = "rank", value.name = "value")

# Create the bar plot
plot <- ggplot(data_melted, aes(x = factor(conditions), y = value, fill = rank)) +
  geom_col() +
  facet_wrap(~ qus) +
  # coord_flip() +
  geom_text(aes(label = value), position = position_stack(vjust = 0.5), colour = "white") +  # Center the text
  scale_fill_manual(values = c("rank1" = "#595959", "rank2" = "#C1C1C1", "rank3" = "#343434")) +  # Custom colors
  labs(x = "Qus and Conditions",
       y = "Value") +
  theme_minimal()

# Display the plot
print(plot)


# preference breakdown based on Friedman + Kendall + Nemenyi test

# Load necessary libraries
library(FSA)        # For the Nemenyi test
library(PMCMRplus)  # For the Nemenyi test

# Input data
scenario_A <- matrix(c(2, 1, 3, 4, 5,
                       1, 3, 5, 2, 4,
                       4, 5, 2, 1, 3),
                     nrow = 3, byrow = TRUE)

# Perform the Friedman test
friedman_result <- friedman.test(scenario_A)
print(friedman_result)

# Calculate Kendall's W
num_raters <- nrow(scenario_A)
num_objects <- ncol(scenario_A)
kendall_chi <- friedman_result$statistic / (sum(scenario_A)^2 - sum(scenario_A)^3 / (length(scenario_A) + 1))
print(kendall_chi)
kendall_w <- (12 * friedman_result$statistic) / (num_raters * num_objects * (num_objects + 1))
print(kendall_w)


# Convert matrix to long data frame format
scenario_A_long <- expand.grid(Rater = factor(1:nrow(scenario_A)), Object = factor(1:ncol(scenario_A)))
scenario_A_long$Rank <- as.vector(t(scenario_A))
# Perform post-hoc pairwise comparisons using the Nemenyi test
nemenyi_result <- frdAllPairsNemenyiTest(Rank ~ Object | Rater, data = scenario_A_long)
print(nemenyi_result)

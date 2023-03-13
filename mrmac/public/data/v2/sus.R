# library
library(ggplot2)
library(ggpubr)
library(dplyr)
library(likert) 
library(agricolae)

coloring = c("#E76469", "#F8D85E","#EDA645","#D1B0B3","#8C99A6","#ADD299","#4FA490","#3B7F9F")
fontsize = 14

data=read.csv('csv/sus.csv', sep=",")
data <- as.data.frame(data) 
data[5:8] <- lapply(data[5:8], factor, levels=1:5, labels=c("Strongly Disagree", "Disagree", "Neutral","Agree","Strongly Agree"))
likt <- likert(data[,c(5:8)], grouping = data$task)
plot(likt, colors = c("#E76469", "#F8D85E","#EDA645","#4FA490","#3B7F9F")) + 
  theme_bw() +
  theme(axis.line = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x = element_text(color="black", size=fontsize),
        axis.text.y = element_text(color="black", size=fontsize),
        strip.text = element_text(color="black", size = fontsize),
        strip.background = element_blank(),
        text = element_text(size=fontsize),
        panel.border = element_blank(),
        plot.background = element_blank(),
        plot.margin = unit(c(0.005, .025, 1, 0), "null"),
        legend.title=element_blank(),
        legend.direction="horizontal",
        legend.position = c(.5, -.1),
        legend.justification = c("center", "top"))

ggsave("out/usability.pdf", width = 6.5, height = 4, dpi = 1000)





# Calculate the descriptive statistics
my_summary <- data %>%
  group_by(task) %>%
  summarize(
    Mean = mean(sus_score),
    Median = median(sus_score),
    SD = sd(sus_score),
    Min = min(sus_score),
    Max = max(sus_score)
  )

# Print the table
my_summary

# Run ANOVA and Tukey's post-hoc test
my_anova <- aov(sus_score ~ task, data = data)
my_tukey <- TukeyHSD(my_anova)


anova_table <- anova(my_anova)
F_val <- anova_table$F[1]
df1 <- anova_table$Df[1]
df2 <- anova_table$Df[2]

# print the results
summary(my_anova)
cat("F(", df1, ", ", df2, ") = ", F_val, "\n")

# Print the Tukey post-hoc test results
my_tukey

# Extract the mean differences, confidence intervals, and p-values
diffs <- my_tukey$`task`[, "diff"]
ci <- my_tukey$`task`[, c("lwr", "upr")]
pvals <- my_tukey$`task`[, "p adj"]

# Create a matrix to store the pairwise comparisons
results <- matrix("", nrow = 3, ncol = 3)

# Compare setosa to versicolor and virginica
results[1, 2] <- ifelse(diffs[1] < 0 & pvals[1] < 0.05, " < ", " = ")
results[1, 3] <- ifelse(diffs[2] < 0 & pvals[2] < 0.05, " < ", " = ")

# Compare virginica to setosa and versicolor
results[3, 1] <- ifelse(diffs[2] > 0 & pvals[2] < 0.05, " > ", " = ")
results[3, 2] <- ifelse(diffs[1] > 0 & pvals[1] < 0.05, " > ", " = ")

# Set versicolor equal to virginica
results[2, 1:3] <- " = "

# Add row and column names
rownames(results) <- c("task1", "task2", "task3")
colnames(results) <- c("task1", "task2", "task3")

# Print the results
results








# Would use system frequently?
# System unnecessarily complex?
# 1. System easy to use?
# Need technical support?
# Functions well integrated?
# System inconsistent?
# Quick to learn system?
# System cumbersome to use?
# Confident using system?
# Steep learning curve?

# Q1. The system made it easier to complete my collaborative task.
# Q2. I found the system's features were straightforward to understand.	
# Q3. I found the system has steep learning curve.	
# Q4. I found the most of the features confusing.

# let susScores = [];

# for (let i = 0; i < 10; i++) {
#   let score = Math.floor(Math.random() * (100 - 82 + 1) + 82);
#   let score = Math.floor(Math.random() * (69 - 50 + 1) + 50);
#   let score = Math.floor(Math.random() * 31);
#   susScores.push(score);
# }

# console.log(susScores);




# Print the mean Sepal.Length of each species
# aggregate(Sepal.Length ~ Species, data = iris, FUN = mean)




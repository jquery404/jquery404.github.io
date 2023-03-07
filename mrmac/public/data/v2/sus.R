# #######
# sus.csv
library(dplyr)
my_data <- read.csv("csv/v2/sus.csv")

# Load SUS data into a data frame
sus_data <- data.frame(
  Group = my_data[,1],
  Participant_ID = my_data[,2],
  Task = my_data[,3],
  SUS_Score = my_data[,4]
)

# Calculate mean and standard deviation for each group-task combination
sus_summary <- aggregate(SUS_Score ~ Group + Task, data = sus_data, FUN = function(x) c(mean = mean(x), sd = sd(x)))

# Print summary table
sus_summary

# calculate mean and standard deviation of SUS score for each task
mean_sus <- aggregate(SUS_Score ~ Task, sus_data, mean)
sd_sus <- aggregate(SUS_Score ~ Task, sus_data, sd)

# print the results
cat("Mean SUS scores by task:\n")
print(mean_sus)
cat("\nStandard deviation of SUS scores by task:\n")
print(sd_sus)


grouped <- sus_data %>%
  group_by(Group, Task) %>%
  summarise(mean = mean(SUS_Score), sd = sd(SUS_Score))

print(grouped)

print ("Therefore, the mean SUS score for Task 1 is 84.375 with a standard deviation of 11.63618, for Task 2 is 68.125 with a standard deviation of 13.17590, and for Task 3 is 70.000 with a standard deviation of 17.29201.")


# Load the necessary packages
library(dplyr)
library(tidyr)
library(agricolae)

# Perform the two-way ANOVA
anova_result <- aov(SUS_Score ~ Group + Task, data = sus_data)

# Display the ANOVA table
summary(anova_result)

# Conduct post-hoc tests
posthoc_result <- HSD.test(anova_result, "Group", group = TRUE)
posthoc_result

posthoc_result <- HSD.test(anova_result, "Task", group = TRUE)
posthoc_result

# Perform the two-way ANOVA
anova_result <- aov(SUS_Score ~ Group + Task, data = sus_data)

# Conduct pairwise comparisons for the Task factor
posthoc_result <- HSD.test(anova_result, "Task", group = TRUE)

# Display the Tukey HSD intervals for pairwise comparisons of Task
posthoc_result

# Create a data frame with the means and standard errors for each task
means <- sus_data %>% 
  group_by(Task) %>% 
  summarize(mean_score = mean(SUS_Score), 
            sd_score = sd(SUS_Score), 
            se_score = sd_score / sqrt(n()))

# load the ggplot2 package for plotting
library(ggplot2)

# Create a boxplot with error bars and labels for the significant differences
ggplot(sus_data, aes(x = factor(Task), y = SUS_Score)) +
  geom_boxplot() +
  geom_errorbar(data = means, aes(x = factor(Task), ymin = mean_score - se_score, ymax = mean_score + se_score), width = 0.2, size = 1.5, inherit.aes = FALSE) +
  xlab("Task") +
  ylab("Sus Score") +
  ggtitle("Sus Score by Task") +
  theme_bw() +
  geom_text(data = posthoc_result$groups, aes(x = Task1, y = mean(Task1) + 10, label = paste0("p = ", round(posthoc_result$groups$pvalue[1], 3))), size = 4) +
  geom_text(data = posthoc_result$groups, aes(x = Task2, y = mean(Task2) + 10, label = paste0("p = ", round(posthoc_result$groups$pvalue[1], 3))), size = 4) +
  geom_text(data = posthoc_result$groups, aes(x = Task3, y = mean(Task3) - 20, label = paste0("p = ", round(posthoc_result$groups$pvalue[1], 3))), size = 4)




# load the car package for ANOVA
library(car)

# conduct a two-way ANOVA with Group and Task as factors
anova_result <- Anova(lm(SUS_Score ~ Group*Task, data=sus_data), type=3)

# print the ANOVA table
print(anova_result)
summary(anova_result)


# load the ggplot2 package for plotting
library(ggplot2)


# create box plots of SUS score by group and task
ggplot(sus_data, aes(x=as.factor(Group), y=SUS_Score)) +
  geom_boxplot(aes(fill=as.factor(Task))) +
  xlab("Group") +
  ylab("SUS score") +
  ggtitle("SUS score by group and task")





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


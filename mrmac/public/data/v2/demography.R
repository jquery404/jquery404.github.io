# #######
# demography.csv
my_data <- read.csv("csv/v2/demography.csv")

# Print the first few rows of the data
head(my_data)

row <- my_data[,1]
dims <- dim(my_data)

data <- data.frame(
  Participant = 1:dims[1],
  Age = my_data[,2],
  Sex = my_data[,3],
  Normal_Corrected = my_data[,4],
  Interact = my_data[,5]
)

# Calculate descriptive statistics for age
summary(data$Age)

# Calculate the number and proportion of participants in each sex category
table(data$Sex)
prop.table(table(data$Sex))

# Calculate the number and proportion of participants in each Normal/Corrected category
table(data$Normal_Corrected)
prop.table(table(data$Normal_Corrected))

# Calculate the number and proportion of participants in each Interact category
table(data$Interact)
prop.table(table(data$Interact))



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

# perform Tukey's HSD test on the Group factor
TukeyHSD(anova_result)

# perform Tukey's HSD test on the Task factor
TukeyHSD(aov(SUS_Score ~ Task, data = sus_data))


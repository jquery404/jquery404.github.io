# library
library(ggplot2)
library(dplyr)
library(broom)
library(tidyr)
library(stats)

coloring = c("#E76469", "#F8D85E","#EDA645","#D1B0B3","#8C99A6","#ADD299","#4FA490","#3B7F9F")
fontsize = 14


df=read.csv('csv/tlx.csv', sep=",")

summary_data <- df %>% 
  group_by(params, task) %>% 
  summarize(mean_score = mean(score), 
            se_score = qnorm(0.975) * sd(score) / sqrt(n()),
            n = n()) %>%
  ungroup()

# Create horizontal bar chart with error bars
order <- c('mental',	'physical',	'temporal',	'effort',	'performance', 'frustration', 'overall')

ggplot(summary_data, aes(x = mean_score, y = factor(params, levels = order), fill = task)) +
  geom_col(width=.5, position=position_dodge(.6)) +
  geom_errorbar(aes(xmin=mean_score-se_score, xmax=mean_score+se_score), width=.2, position=position_dodge(.6))+
  scale_fill_manual(values = coloring) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 50)) +
  guides(fill=guide_legend(title="")) +
  theme_bw() +
  theme(axis.line = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x = element_text(color="black", size=fontsize),
        axis.text.y = element_text(color="black", size=fontsize),
        text = element_text(size=fontsize),
        strip.background = element_blank(),
        plot.background = element_blank(),
        plot.margin = unit(c(0.005, .025, 0, 0), "null"),
        panel.border = element_blank(),
        panel.spacing = unit(c(0, 0, 0, 0), "null"),
        legend.position = c(.95, 0.3),
        legend.justification = c("right", "top"),
        legend.title=element_blank(),
        legend.text=element_text(size=fontsize),
        legend.box.just = "right",
        legend.box.background = element_rect(fill = "white", color = "black", size = 1))


ggsave("out/rtlx.pdf", width = 6.5, height = 4.8, dpi = 1000)



# Task complexity 
df=read.csv('csv/task-completion.csv', sep=",")

# Convert the data from wide format to long format
df_long <- df %>%
  pivot_longer(cols = c(task1, task2, task3), names_to = "task", values_to = "time")

# Sort the data by task and time
completion_times <- df_long %>%
  arrange(task, time)

# Calculate the mean, median, and standard deviation for each task completion time
task_stats <- completion_times %>%
  group_by(task) %>%
  summarize(mean_time = mean(time), median_time = median(time), sd_time = sd(time))



# One-Way ANOVA
model <- aov(time ~ task, data = completion_times)
anova_table <- anova(model)
F_val <- anova_table$F[1]
df1 <- anova_table$Df[1]
df2 <- anova_table$Df[2]

# print the results
summary(model)
cat("F(", df1, ", ", df2, ") = ", F_val, "\n")


# Bartlett's test
bartlett_test <- bartlett.test(time ~ task, data = completion_times)
# Create a data frame to store the test results
test_results <- data.frame(
  statistic = bartlett_test$statistic,
  p.value = bartlett_test$p.value,
  parameter = bartlett_test$parameter
)

# Create a string
my_string <- paste(
  "Bartlett's K-squared = ", bartlett_test$statistic, 
  ", df=", bartlett_test$parameter, 
  ", p-value =", bartlett_test$p.value, 
  ", Sigf = ", bartlett_test$p.value < 0.05,
  ", F-stats: ", capture.output(cat("F(", df1, ", ", df2, ") = ", F_val, "\n")))
bartlett_stats <- data.frame(my_string)


# Save the resulting data frame as a CSV file
write.csv(task_stats, file = "out/task_stats.csv", row.names = FALSE)
write.csv(bartlett_stats, file = "out/task_f_bartlett.csv", row.names = FALSE)





library(ggplot2)

# Create example data
group1 <- c(5, 8, 7, 6)
group2 <- c(3, 6, 4, 5)
df <- data.frame(group = rep(c("Group 1", "Group 2"), each = 4),
                 value = c(group1, group2))

# Calculate mean and standard deviation for each group
means <- aggregate(df$value, list(df$group), mean)
names(means) <- c("group", "mean")
stddev <- aggregate(df$value, list(df$group), sd)
names(stddev) <- c("group", "sd")

# Calculate p-value for difference between groups
pval <- t.test(group1, group2)$p.value

# Calculate p-value for difference between groups
pval <- t.test(group1, group2)$p.value

# Determine the level of significance
if (pval < 0.001) {
  significance <- "***"
} else if (pval < 0.01) {
  significance <- "**"
} else if (pval < 0.05) {
  significance <- "*"
} else {
  significance <- "ns"
}

# Create bar chart
ggplot(df, aes(x = group, y = value, fill = group)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = means$mean[1] - stddev$sd[1], 
                    ymax = means$mean[1] + stddev$sd[1]), 
                width = 0.2, position = position_dodge(width = 0.9)) +
  geom_errorbar(aes(ymin = means$mean[2] - stddev$sd[2], 
                    ymax = means$mean[2] + stddev$sd[2]), 
                width = 0.2, position = position_dodge(width = 0.9)) +
  labs(title = "Vertical Bar Chart with Two Groups",
       x = "Group", y = "Value") +
  theme_minimal() +
  scale_fill_manual(values = c("Group 1" = "blue", "Group 2" = "red")) +
  annotate("text", x = 1.5, y = 9, 
           label = paste("p =", round(pval, 3), significance), 
           color = "black", size = 4)









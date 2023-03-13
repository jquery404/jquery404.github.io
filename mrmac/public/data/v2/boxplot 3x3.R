# Load the required libraries
library(ggplot2)
library(tidyverse)
library(rstatix)
library(ggpubr)

# Create a sample dataset with subgroups
set.seed(123)
group1.sub1 <- rnorm(20, 9, 1)
group1.sub2 <- rnorm(20, 11, 1)
group1.sub3 <- rnorm(10, 12, 1)
group2.sub1 <- rnorm(20, 11, 1)
group2.sub2 <- rnorm(20, 13, 1)
group2.sub3 <- rnorm(10, 14, 1)
group3.sub1 <- rnorm(20, 14, 1)
group3.sub2 <- rnorm(20, 16, 1)
group3.sub3 <- rnorm(10, 17, 1)
data <- data.frame(value = c(group1.sub1, group1.sub2, group1.sub3, 
                             group2.sub1, group2.sub2, group2.sub3,
                             group3.sub1, group3.sub2, group3.sub3),
                   group = rep(c("Group 1", "Group 2", "Group 3"), each = 50),
                   subgroup = rep(rep(c("Subgroup 1", "Subgroup 2", "Subgroup 3"), each = 10), times = 3),
                   group_subgroup = rep(c("Group 1:Subgroup 1", "Group 1:Subgroup 2", "Group 1:Subgroup 3",
                                          "Group 2:Subgroup 1", "Group 2:Subgroup 2", "Group 2:Subgroup 3",
                                          "Group 3:Subgroup 1", "Group 3:Subgroup 2", "Group 3:Subgroup 3"), each = 50))

# Perform one-way ANOVA
model <- aov(value ~ group * subgroup, data = data)
summary(model)

# Perform pairwise t-tests with Benjamini-Hochberg correction
pwc <- pairwise_t_test(data, value ~ group_subgroup, within = group_subgroup, p.adjust.method = "BH")


# Create a boxplot with a significant difference bar, BH,
p <- ggboxplot(data, x = "group_subgroup", y = "value", color = "group", palette = "jco") + 
  stat_compare_means(comparisons = list(c("Group 1:Subgroup 1", "Group 1:Subgroup 2"), 
                                        c("Group 1:Subgroup 2", "Group 1:Subgroup 3"),
                                        c("Group 2:Subgroup 1", "Group 2:Subgroup 2"), 
                                        c("Group 2:Subgroup 2", "Group 2:Subgroup 3"),
                                        c("Group 3:Subgroup 1", "Group 3:Subgroup 2"), 
                                        c("Group 3:Subgroup 2", "Group 3:Subgroup 3")),
                     method = "t.test", p.adjust.method = "BH",
                     label = "p.signif", symbol = "p", size = 4)

p
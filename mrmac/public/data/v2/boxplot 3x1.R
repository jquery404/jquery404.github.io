# Load the required libraries
library(ggplot2)
library(tidyverse)
library(rstatix)
library(ggpubr)

# Create a sample dataset
set.seed(123)
group1 <- rnorm(50, 10, 2)
group2 <- rnorm(50, 12, 2)
group3 <- rnorm(50, 15, 2)
data <- data.frame(value = c(group1, group2, group3),
                   group = rep(c("Group 1", "Group 2", "Group 3"), each = 50))

# Perform one-way ANOVA
model <- aov(value ~ group, data = data)
summary(model)

# Perform pairwise t-tests with Benjamini-Hochberg correction
pwc <- pairwise_t_test(data, value ~ group, p.adjust.method = "BH")

# Create a boxplot with significance symbols
p <- ggboxplot(data, x = "group", y = "value", color = "group", palette = "jco") + 
  stat_compare_means(comparisons = list(c("Group 1", "Group 2"), c("Group 2", "Group 3")),
                     method = "t.test", p.adjust.method = "BH", label = "p.signif",
                     symbol = "p", size = 5)
p


library(ggplot2)
library(ggpubr)


data("iris")
anno <- t.test(
  iris[iris$Petal.Width > 1 & iris$Species == "versicolor", "Sepal.Width"],
  iris[iris$Species == "virginica", "Sepal.Width"]
)$p.value

# Make plot with custom x and y position of the bracket
ggplot(iris, aes(x = Species, y = Sepal.Width, fill = Petal.Width > 1)) +
  geom_boxplot(position = "dodge") +
  geom_signif(
    annotation = "*",
    y_position = 4, xmin = 2.2, xmax = 3,
    tip_length = c(0.2, 0.04)
  )


# Required packages
library(ggpubr)  # https://github.com/kassambara/ggpubr
library(rstatix)  # https://github.com/kassambara/rstatix

# Add automatically x and y positions
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
bxp <- ggplot(ToothGrowth, aes(x = dose, y = len)) +
  geom_boxplot(aes(fill = supp))
stat.test <- ToothGrowth %>% 
  group_by(dose) %>% 
  wilcox_test(len~supp, p.adjust.method = 'BH') %>%
  add_significance("p") %>%
  add_xy_position(x = "dose")
bxp + stat_pvalue_manual(stat.test, label = 'p.signif', hide.ns = TRUE, tip.length = 0.02)
write.csv(ToothGrowth, file = "csv/sp.csv", row.names = FALSE)

# Add automatically x and y positions
df=read.csv('csv/sp.csv', sep=",")
df$dose <- as.factor(df$dose)
bxp <- ggplot(df, aes(x = dose, y = len)) +
  geom_boxplot(aes(fill = supp))
stat.test <- df %>% 
  group_by(dose) %>% 
  wilcox_test(len~supp, p.adjust.method = 'BH') %>%
  add_significance("p") %>%
  add_xy_position(x = "dose")
bxp + stat_pvalue_manual(stat.test, label = 'p.signif', hide.ns = TRUE, tip.length = 0.02)


# Add automatically x and y positions
df=read.csv('csv/social.csv', sep=",")
bxp <- ggplot(df, aes(x = params, y = score)) +
  geom_boxplot(aes(fill = conditions))
stat.test <- df %>% 
  group_by(params) %>% 
  wilcox_test(score~conditions, p.adjust.method = 'BH') %>%
  add_significance("p") %>%
  add_xy_position(x = "params")
bxp + stat_pvalue_manual(stat.test, label = 'p.signif', hide.ns = TRUE, tip.length = 0.02)

# saving the final figure
ggsave("out/social.pdf", width = 6.5, height = 4, dpi = 1000)


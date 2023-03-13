library(ggplot2)
library(ggpubr)

df=read.csv('csv/social.csv', sep=",")

# create the boxplot
p <- ggplot(df, aes(x = params, y = score, fill = task)) +
  geom_boxplot() +
  labs(x = "Params", y = "Score", fill = "Task") +
  theme_bw()

# Make plot with custom x and y position of the bracket
p +
  geom_signif(
    annotation = "*",
    y_position = 7.2, xmin = 0.75, xmax = 1,
    tip_length = c(0.02, 0.02)
  )



# create the boxplot and add statistical tests
p <- ggplot(df, aes(x = params, y = score, fill = task)) +
  geom_boxplot() +
  labs(x = "Params", y = "Score", fill = "Task") +
  theme_bw() +
  stat_compare_means(method = "anova", label = "p.signif", hide.ns = TRUE)


# modify the significance labels
p + scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +
  geom_signif(
    pairwise = c("task 1", "task 2", "task 3"),
    test = "t.test", comparisons = list(c(1, 2), c(1, 3), c(2, 3)),
    textsize = 3, tip_length = 0.01, vjust = -0.5, step_increase = 0.05
  ) 

p + geom_signif(stat = "identity",
                data = data.frame(x = c(0.7, 1.7, 2.7),
                                  xend = c(1.3, 2.3, 3.3),
                                  y = c(1.5, 2.5, 4.5),
                                  annotation = c("NS.", "***", "*")))

# create the boxplot and add statistical tests
p <- ggplot(df, aes(x = task, y = score, fill = task)) +
  geom_boxplot() +
  labs(x = "Task", y = "Score", fill = "") +
  theme_bw() +
  facet_wrap(~ params, scales = "free_x") +
  stat_compare_means(method = "t.test", label = "p.signif", hide.ns = TRUE)

# modify the significance labels
p + scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +
  geom_signif(
    test = "t.test", comparisons = list(c(1, 2), c(1, 3), c(2, 3)),
    textsize = 3, tip_length = 0.01, vjust = -0.5, step_increase = 0.05
  ) +
  theme(legend.position = "none")



# saving the final figure
ggsave("out/social_presence.png", width = 6, height = 6, dpi = 1000)




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





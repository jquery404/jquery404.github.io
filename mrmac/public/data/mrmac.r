# library
library(ggplot2)
library(ggpubr)
library(dplyr)
library(likert) 
coloring = c("#E76469", "#F8D85E","#EDA645","#D1B0B3","#8C99A6","#ADD299","#4FA490","#3B7F9F")
fontsize = 14

##############################
###### Social Presence #######
##############################

# create a data frame
social_data =read.csv('csv/social-presence.csv', sep=",")
attach(social_data)

# analysis of variance
anova = aov(score ~params, data=social_data)
summary(anova)

# pairwise comp
tukey = TukeyHSD(anova)
print(tukey)

# grouped box plot
social_plt <- ggplot(data = social_data, mapping = aes(x = params, y = score, fill = vrar)) +
  stat_boxplot(geom = "errorbar", width=.2, position=position_dodge(.75)) +
  geom_boxplot(aes(color=vrar), coef = 0, outlier.alpha = 0, show.legend = F) +
  # geom_point(position=position_jitterdodge(dodge.width=0.9)) +
  stat_compare_means(method="t.test") + 
  geom_segment(data=social_data, aes(x=params, xend=params, y=3.5, yend=3.5), colour="red", size=2, inherit.aes = F)  + 
  stat_summary(fun="mean", geom="point", shape=1, size=3, position=position_dodge(width=0.75), color="black") + 
  stat_summary(geom = "crossbar", width=0.65, fatten=0, color="black", fun.data = function(x){c(y=median(x), ymin=median(x), ymax=median(x))}, position=position_dodge(width=0.75)) +
  scale_fill_manual(name= "vrar", values = c("#E76469", "#F8D85E")) +
  scale_color_manual(name = "vrar", values = c("#E76469", "#F8D85E")) + 
  scale_y_continuous(minor_breaks = seq(0, 7, 1), breaks = seq(1, 7.1, by=1), limits=c(1,7.1)) + 
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
        #panel.grid.major = element_blank(),
        legend.position = c(.95, 0.2),
        legend.justification = c("right", "top"),
        legend.title=element_blank(),
        legend.text=element_text(size=fontsize),
        legend.box.just = "right",
        legend.box.background = element_rect(fill = "white", color = "black", size = 1))

social_plt

# saving the final figure
ggsave("social_presence.png", width = 6, height = 6, dpi = 1000)



##############################
###### Spatial Presence ######
##############################

# create a data frame
spatial_data=read.csv('csv/spatial-presence.csv', sep=",")
attach(spatial_data)

# analysis of variance
anova = aov(score ~params, data=spatial_data)
summary(anova)
shapiro.test(gfg$score)


# pairwise comp
tukey = TukeyHSD(anova)
print(tukey)

# grouped box plot
spatial_plt <- ggplot(data = spatial_data, mapping = aes(x = params, y = score, fill = vrar)) +
  stat_boxplot(geom = "errorbar", width=.2, position=position_dodge(.75)) +
  geom_boxplot() +
  geom_boxplot(aes(color=vrar), coef = 0, outlier.alpha = 0, show.legend = F) +
  # geom_point(position=position_jitterdodge(dodge.width=0.9)) +
  #stat_compare_means(method="t.test") + 
  stat_summary(fun="mean", geom="point", shape=1, size=3, position=position_dodge(width=0.75), color="black") + 
  stat_summary(geom = "crossbar", width=0.65, fatten=0, color="black", fun.data = function(x){c(y=median(x), ymin=median(x), ymax=median(x))}, position=position_dodge(width=0.75)) +
  scale_fill_manual(name= "vrar", values = c("#E76469", "#F8D85E"))+
  scale_color_manual(name = "vrar", values = c("#E76469", "#F8D85E")) + 
  scale_y_continuous(minor_breaks = seq(0, 7, 1), breaks = seq(1, 7.1, by=1), limits=c(1,7.1)) +
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
        #panel.grid.major = element_blank(),
        legend.position = c(.95, 0.2),
        legend.justification = c("right", "top"),
        legend.title=element_blank(),
        legend.text=element_text(size=fontsize),
        legend.box.just = "right",
        legend.box.background = element_rect(fill = "white", color = "black", size = 1))
spatial_plt

ggsave("spatial_presence.png", width = 6, height = 6, dpi = 1000)


#############################
### combine #################
############################

ggarrange(social_plt, spatial_plt, ncol = 2, nrow = 1, widths = c(1, .5))



##############################
############ RTLX ############
##############################

gfg=read.csv('csv/nasa-tlx.csv', sep=",")
attach(gfg)

# grouped box plot
ggplot(data = gfg, mapping = aes(x = params, y = score, fill = vrar)) +
  stat_boxplot(geom = "errorbar") +
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 100)) +
  #scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9")) + 
  theme(legend.text=element_text(size=10), 
        legend.title=element_text(size=10, hjust=0.5), 
        legend.key.height = unit(1,"cm"), 
        legend.key.width = unit(1,"cm"), 
        legend.position = c(0.9, 0.9)) + 
  guides(fill=guide_legend(title="")) 

# saving the final figure
ggsave("rtlx.png", width = 6, height = 6, dpi = 1000)

#######################################
############ RTLX BARCHART ############
#######################################

gfg=read.csv('csv/nasa-tlx.csv', sep=",")
attach(gfg)

cleandata <- gfg %>%
  group_by(params, vrar) %>%
  summarise(mean_score = mean(score), 
            counts = n(), 
            sd_score = sd(score), 
            se_score = (sd_score/sqrt(sd_score))
            )

View(cleandata)

# grouped box plot
level_order <- c('mental',	'physical',	'temporal',	'effort',	'performance', 'frustration', 'overall')
ggplot(data=cleandata, mapping= aes(x=factor(params, level = level_order), y=mean_score, fill=vrar)) +
  geom_col(width=.5, position=position_dodge(.6)) +
  geom_errorbar(aes(ymin=mean_score-se_score, ymax=mean_score+se_score), width=.2, position=position_dodge(.6))+
  scale_fill_manual(values = coloring) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_flip(ylim = c(0, 100)) +
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

# saving the final figure
ggsave("rtlx.png", width = 6, height = 6, dpi = 1000)



#######################################
# usability likert bar chart #
#######################################


data=read.csv('csv/usability.csv', sep=",")
data <- as.data.frame(data) 
data[2:5] <- lapply(data[2:5], factor, levels=1:5, labels=c("Strongly Disagree", "Disagree", "Neutral","Agree","Strongly Agree"))
likt <- likert(data[,c(2:5)], grouping = data$item)
plot(likt, colors = c("#E76469", "#F8D85E","#EDA645","#4FA490","#3B7F9F")) + 
  theme_bw() +
  theme(axis.line = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x = element_text(color="black", size=fontsize),
        axis.text.y = element_text(color="black", size=fontsize),
        strip.text = element_text(color="black", face="bold", size = fontsize),
        strip.background = element_blank(),
        text = element_text(size=fontsize),
        panel.border = element_blank(),
        plot.background = element_blank(),
        plot.margin = unit(c(0.005, .025, 1, 0), "null"),
        legend.title=element_blank(),
        legend.direction="horizontal",
        legend.position = c(.5, -.1),
        legend.justification = c("center", "top"))
write.csv(foo,"File Name.csv", row.names = FALSE)


#######################################
# preference stack bar chart #
#######################################
data=read.csv('csv/preference.csv', sep=",")

ggplot(data %>% count(qus, ans) %>% 
         mutate(pct=n), aes(qus, n, fill=ans)) +
  geom_bar(stat="identity", position = "fill") +
  scale_fill_manual(values = coloring) +
  coord_flip(ylim = c(0, 1)) +
  geom_text(aes(label=pct), position=position_fill(vjust=0.5))



#######################################
# preference horizontal box plot #
#######################################
data=read.csv('csv/preference.csv', sep=",")
pref_bg="#E76469"
pref_color= "#d1353b"
data$qus <- factor(data$qus, levels = c(
  "Q10 ...overall experience comfortable for you?",
  "Q9 ...feel the presence of the remote users?",
  "Q8 ...feel you were there in the remote space?",
  "Q7 ...tools were sufficient to perform your tasks?",
  "Q6 ...got necessary feedback from others?",
  "Q5 ...comfortable communicating with remote user avatar?",
  "Q4 ...able to effectively communicate with others?",
  "Q3 ...rate the overall audio quality?",
  "Q2 ...rate the overall video quality?",
  "Q1 ...able to clearly hear and see in the remote space?"))


g <- ggplot(data = data, mapping = aes(x = qus, y = ans, fill = qus)) +
  stat_boxplot(geom = "errorbar", width=.2, color=pref_color, position=position_dodge(.75)) +
  geom_boxplot(color=pref_bg, fill=pref_bg) +
  stat_summary(fun="mean", geom="point", shape=1, size=3, position=position_dodge(width=0.75), color=pref_color) + 
  stat_summary(geom = "crossbar", width=0.7, fatten=3, color=pref_color, fun.data = function(x){c(y=median(x), ymin=median(x), ymax=median(x))}, position=position_dodge(width=0.75))+
  scale_y_continuous(minor_breaks = seq(1, 7, 1), breaks = seq(1, 7.1, by=1), limits=c(1,7.1), c(0, 0)) +
  coord_flip(ylim = c(1, 7))

g + 
  theme_bw() + 
  theme(axis.line = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x = element_text(color="black", size=fontsize),
        axis.text.y = element_text(color="black", size=fontsize),
        strip.text = element_text(color="black", face="bold", size = fontsize),
        strip.background = element_blank(),
        panel.border = element_blank(),
        plot.background = element_blank(),
        plot.margin = unit(c(0.005, .025, 0, 0), "null"),
        panel.spacing = unit(c(0, 0, 0, 0), "null"),
        legend.position = "none")


ggsave("spatial_presence.png", width = 6, height = 6, dpi = 1000)
  


# latency and scalibility
data=read.csv('csv/latency.csv', sep=",")

g <- barplot(as.matrix(data), horiz = TRUE) 


df2 <- data.frame(supp=rep(c("VC", "OJ"), each=3),
                  dose=rep(c("D0.5", "D1", "D2"),2),
                  len=c(6.8, 15, 33, 4.2, 10, 29.5))
g <- ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity") +
  coord_flip()

g + 
  theme_bw() + 
  theme(axis.line = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x = element_text(color="black", size=fontsize),
        axis.text.y = element_text(color="black", size=fontsize),
        strip.text = element_text(color="black", face="bold", size = fontsize),
        strip.background = element_blank(),
        panel.border = element_blank(),
        plot.background = element_blank(),
        plot.margin = unit(c(0.005, .025, 0, 0), "null"),
        panel.spacing = unit(c(0, 0, 0, 0), "null"),
        legend.position = "none")

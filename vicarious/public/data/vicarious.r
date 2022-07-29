#1. social presence and spatial presence 
#2. task workload using Raw-TLX
#3. system usability scale (also add table)
#4. user preference from post q&a 


# library
library(ggplot2)
library(ggpubr)
library(dplyr)
library(likert) 
coloring = c("#ffbd66", "#ffebd0","#d7f0f2","#90d7de","#52c2cc","#b56576","#6d597a","#355070")
fontsize = 14
dodge = .35

##############################
###### Social Presence #######
##############################
bar_color = c("#ffbd66", "#90d7de")
# create a data frame
social_data =read.csv('csv/social presence.csv', sep=",")
attach(social_data)

# analysis of variance
anova = aov(score ~params, data=social_data)
summary(anova)

# pairwise comp
tukey = TukeyHSD(anova)
print(tukey)

# grouped box plot
social_plt <- ggplot(data = social_data, mapping = aes(x = params, y = score, fill = vrar)) +
  stat_boxplot(geom = "errorbar", width=.2, position=position_dodge(dodge)) +
  geom_boxplot(aes(color=vrar), width = dodge, coef = 0, outlier.alpha = 0, show.legend = F) +
  # geom_point(position=position_jitterdodge(dodge.width=0.9)) +
  stat_compare_means(method="t.test") + 
  #geom_segment(data=social_data, aes(x=params, xend=params, y=3.5, yend=3.5), colour="red", size=2, inherit.aes = F)  + 
  stat_summary(fun="mean", geom="point", shape=1, size=3, position=position_dodge(width=dodge), color="black") + 
  stat_summary(geom = "crossbar", width=dodge*.9, fatten=0, color="black", fun.data = function(x){c(y=median(x), ymin=median(x), ymax=median(x))}, position=position_dodge(width=dodge)) +
  scale_fill_manual(name= "vrar", values = bar_color) +
  scale_color_manual(name = "vrar", values = bar_color) + 
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
ggsave("social-presence.pdf")



##############################
###### Spatial Presence ######
##############################

# create a data frame
spatial_data=read.csv('csv/spatial presence.csv', sep=",")
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
  stat_boxplot(geom = "errorbar", width=.2, position=position_dodge(dodge)) +
  geom_boxplot(aes(color=vrar), width = dodge, coef = 0, outlier.alpha = 0, show.legend = F) +
  # geom_point(position=position_jitterdodge(dodge.width=0.9)) +
  stat_compare_means(method="t.test") + 
  #geom_segment(data=social_data, aes(x=params, xend=params, y=3.5, yend=3.5), colour="red", size=2, inherit.aes = F)  + 
  stat_summary(fun="mean", geom="point", shape=1, size=3, position=position_dodge(width=dodge), color="black") + 
  stat_summary(geom = "crossbar", width=dodge*.9, fatten=0, color="black", fun.data = function(x){c(y=median(x), ymin=median(x), ymax=median(x))}, position=position_dodge(width=dodge)) +
  scale_fill_manual(name= "vrar", values = bar_color) +
  scale_color_manual(name = "vrar", values = bar_color) + 
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

ggsave("spatial-presence.pdf")


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

rtlx_data=read.csv('csv/nasa-tlx.csv', sep=",")
pref_color = c("#90d7de", "#ffbd66","#ffebd0")
rtlx_data$mode <- factor(rtlx_data$mode, level = c("automatic", "suggestive", "manual"))
attach(rtlx_data)

cleandata <- rtlx_data %>%
  group_by(params, mode) %>%
  summarise(mean_score = mean(score), 
            counts = n(), 
            sd_score = sd(score), 
            se_score = (sd_score/sqrt(sd_score))
            )

View(cleandata)

friedman.test(y=cleandata$mean_score, groups=cleandata$mode, blocks=cleandata$params)
wilcox <- pairwise.wilcox.test(cleandata$mean_score, cleandata$mode, p.adj = "bonf")

print(wilcox)

Zstat<-qnorm(wilcox$p.value/2)
print(Zstat)
print(abs(Zstat)/sqrt(20))


# grouped box plot
level_order <- c('remote user',	'local user',	'overall')
ggplot(data=cleandata, mapping= aes(x=factor(params, level = level_order), y=mean_score, fill=mode)) +
  geom_col(width=.5, position=position_dodge(.6)) +
  geom_errorbar(aes(ymin=mean_score-se_score, ymax=mean_score+se_score), width=.2, position=position_dodge(.6))+
  scale_fill_manual(breaks=c('manual', 'suggestive', 'automatic'), values = pref_color) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_flip(ylim = c(0, 50)) +
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
        panel.spacing = unit(c(0, 0, 0, 0), "null"),
        panel.grid.major = element_blank(),
        panel.border = element_blank(),
        legend.position = c(.95, 0.3),
        legend.justification = c("right", "top"),
        legend.title=element_blank(),
        legend.text=element_text(size=fontsize),
        legend.box.just = "right",
        legend.box.background = element_rect(fill = "white", color = "black", size = 1))

# saving the final figure
ggsave("rtlx.pdf")



#######################################
# usability box plot
#######################################


usability_data=read.csv('csv/usability.csv', sep=",")
pref_color = c("#90d7de", "#ffbd66","#ffebd0")
usability_data$mode <- factor(usability_data$mode, level = c("automatic", "suggestive", "manual"))


attach(usability_data)

cleandata <- usability_data %>%
  group_by(params, mode) %>%
  summarise(mean_score = mean(score), 
            counts = n(), 
            sd_score = sd(score), 
            se_score = (sd_score/sqrt(sd_score))
  )

View(cleandata)

friedman.test(y=cleandata$mean_score, groups=cleandata$mode, blocks=cleandata$params)
pairwise.wilcox.test(cleandata$mean_score, cleandata$mode, p.adj = "bonf")

# grouped box plot
level_order <- c('remote user',	'local user')
ggplot(data=cleandata, mapping= aes(x=factor(params, level = level_order), y=mean_score, fill=mode)) +
  geom_col(width=.5, position=position_dodge(.6)) +
  geom_errorbar(aes(ymin=mean_score-se_score, ymax=mean_score+se_score), width=.2, position=position_dodge(.6))+
  scale_fill_manual(breaks=c('manual', 'suggestive', 'automatic'), values = pref_color) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_flip(ylim = c(0, 100)) +
  guides(fill=guide_legend(title="", override.aes = list(color = NA))) +
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
        panel.spacing = unit(c(0, 0, 0, 0), "null"),
        panel.grid.major = element_blank(),
        panel.border = element_blank(),
        legend.position = c(.95, 0.3),
        legend.justification = c("right", "top"),
        legend.title=element_blank(),
        legend.text=element_text(size=fontsize),
        legend.box.just = "right",
        legend.box.background = element_rect(fill = "white", color = "black", size = 1))

# saving the final figure
ggsave("usability.pdf")


#######################################
# preference stack bar chart #
#######################################
pref_color = c("#90d7de", "#ffbd66","#ffebd0")
data=read.csv('csv/preference.csv', sep=",")

data$tech <- factor(data$tech, levels = c("automatic", "suggestive", "manual"))
data$qus <- factor(data$qus, levels = c("q4... did you prefer overall?",
                                        "q3... made you feel more present with the remote users?", 
                                        "q2... made you feel more present in the virtual environment?", 
                                        "q1... did you find the easiest to use?"))

ggplot(data, aes(x=tech, y=ans, fill=tech)) +
  geom_col(aes(x = qus, y = ans, fill = tech)) +
  scale_fill_manual(breaks=c('manual', 'suggestive', 'automatic'), values = pref_color) +
  scale_color_manual(values = pref_color) + 
  coord_flip(ylim = c(0, 100)) +
  geom_text(aes(x = qus, y = ans, label = paste0(ans,"%")), position = position_stack(vjust = .5)) +
  ggtitle('Which of the three viewpoint selection and transition techniques') + 
  theme_bw() + 
  theme(axis.line = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", size=fontsize),
        strip.text = element_text(color="black", face="bold", size = fontsize),
        strip.background = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = fontsize, face = "bold", hjust = 0, vjust = .5),
        plot.background = element_blank(),
        plot.margin = unit(c(0, .025, 0, 0), "null"),
        panel.spacing = unit(c(0, 0, 0, 0), "null"),
        legend.position = "bottom",
        legend.justification = c("center", "top"),
        legend.title=element_blank(),
        legend.text=element_text(size=fontsize),
        legend.box.just = "center",
        legend.box.background = element_blank()) 

# saving the final figure
ggsave("preference.pdf")


#######################################
# preference horizontal box plot #
#######################################
data=read.csv('csv/preference.csv', sep=",")
pref_bg="#E76469"
pref_color= "#d1353b"

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




#######################################
# task completion 
#######################################
data=read.csv('csv/timecompletion.csv', sep=",")

shapiro.test(data$time)

res.aov <- aov(data$time ~ data$tech, data = data)
summary(res.aov)

plot(TukeyHSD(res.aov, conf.level = .95))
plot(TukeyHSD(res.aov, "tension"))

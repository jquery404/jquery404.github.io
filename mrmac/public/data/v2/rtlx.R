#######################################
############ RTLX BARCHART ############
#######################################

# library
library(ggplot2)
library(ggpubr)
library(dplyr)
library(likert) 
coloring = c("#E76469", "#F8D85E","#EDA645","#D1B0B3","#8C99A6","#ADD299","#4FA490","#3B7F9F")
fontsize = 14


gfg=read.csv('csv/tlx.csv', sep=",")
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
level_order <- c('Mental Demand',	'Physical Demand',	'Temporal Demand',	'Effort',	'Performance', 'Frustration', 'Overall')
ggplot(data=cleandata, mapping= aes(x=factor(params, level = level_order), y=mean_score, fill=vrar)) +
  geom_col(width=.5, position=position_dodge(.6)) +
  geom_errorbar(aes(ymin=mean_score-se_score, ymax=mean_score+se_score), width=.2, position=position_dodge(.6))+
  scale_fill_manual(values = coloring) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_flip(ylim = c(0, 40)) +
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
ggsave("out/rtlx.pdf", width = 6, height = 6, dpi = 1000)
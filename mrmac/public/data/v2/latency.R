dat <- read.table(text = "A   B   C
1 48 780 431
2 720 350 377
3 460 480 179
4 220 240 876", header = TRUE)

library(reshape2)

dat$row <- seq_len(nrow(dat))
dat2 <- melt(dat, id.vars = "row")

library(ggplot2)

ggplot(dat2, aes(x = variable, y = value, fill = row)) + 
  geom_bar(stat = "identity") +
  xlab("\nType") +
  ylab("Time\n") +
  coord_flip() +
  theme_bw()

test  <- data.frame(person=c("A", "B", "C", "D", "E"), 
                    value1=c(100,150,120,80,150),     
                    value2=c(25,30,45,30,30) , 
                    value3=c(100,120,150,150,200)) 
melted <- melt(test, "person")

melted$cat <- ''
melted[melted$variable == 'value1',]$cat <- "local"
melted[melted$variable != 'value1',]$cat <- "remote"

ggplot(melted, aes(x = cat, y = value, fill = variable)) + 
  geom_bar(stat = 'identity', position = 'stack') + facet_grid(~ person)
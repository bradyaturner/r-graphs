#!/usr/bin/env Rscript

library(ggplot2)

data <- read.csv("stdin")

# do this for each column except date and time
a <- ggplot( data, aes(x=timestamp, y=play.hw.0)) + geom_line()

plot(a)

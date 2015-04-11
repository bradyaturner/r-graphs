#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)

source("multiplot.r")

# read piped-in data
data <- read.csv("stdin")

# make a copy of the data
d2 <- data

# get rid of date column
d2$date <- NULL

# get rid of record column TEMPORARY
d2$rec.hw.0 <- NULL

#Melt into long format with first column as the id variable
d2.m <- melt(d2, id.vars = 1)

# Line plot with labels
p <- ggplot(d2.m, aes(timestamp,value, color=variable)) +
      geom_line() +
      ggtitle("Latency Test Results") +
      ylab("Latency (s)") +
      xlab("Time (s)")
# Plot as pdf
plot(p)

p2 <- ggplot(data, aes(x=timestamp, play.hw.0Src)) + geom_line()
p3 <- ggplot(data, aes(x=timestamp, play.hw.0)) + geom_line()

plot(p2)
plot(p3)

multiplot(p2,p3)

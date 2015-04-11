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
      xlab("Time (s)") +
      labs(color = "Measurement")
# Plot as pdf
plot(p)

# copy the data
d3 <- d2
d3$timestamp <- NULL

# individual graphs of each dataset
for (i in names(d3)) {
  p4 <- ggplot(data, aes(x=timestamp, y=data[[i]])) +
          geom_line() +
          geom_point() +
          ggtitle(i) +
          ylab("Latency (s)") +
          xlab("Time (s)")
          plot(p4)
}

# Two plots on same page using multiplot
p2 <- ggplot(data, aes(x=timestamp, play.hw.0Src)) +
        geom_line() +
        ggtitle("play.hw.0Src") +
        ylab("Latency (s)") +
        xlab("Time (s)")
p3 <- ggplot(data, aes(x=timestamp, play.hw.0)) +
        geom_line() +
        ggtitle("play.hw.0") +
        ylab("Latency (s)") +
        xlab("Time (s)")
multiplot(p2,p3)

# All datasets plotted using facet_wrap
p5 <- ggplot(d2.m, aes(timestamp,value)) +
        geom_line() +
        ylab("Latency (s)") +
        xlab("Time (s)") +
        facet_wrap(~variable, scales="free", ncol=1)
print(p5)

#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)
library(scales)

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
p <- ggplot(d2.m, aes(x=timestamp,y=value, color=variable)) +
      geom_line() +
      scale_y_continuous(labels = comma) +
      ggtitle("Latency Test Results") +
      ylab("Latency (s)") +
      xlab("Time (s)") +
      labs(color = "Measurement")
# Plot as pdf
print(p)

# copy the data & remove timestamp column
d3 <- d2
d3$timestamp <- NULL

# individual graphs of each dataset (w/ points)
for (i in names(d3)) {
  p4 <- ggplot(data, aes(x=timestamp, y=data[[i]])) +
          geom_line() +
          geom_point() +
          scale_y_continuous(labels = comma) +
          ggtitle(i) +
          ylab("Latency (s)") +
          xlab("Time (s)")
          plot(p4)
}

# All datasets plotted using facet_wrap
p5 <- ggplot(d2.m, aes_string(x="timestamp",y="value")) +
        geom_line() +
        ylab("Latency (s)") +
        xlab("Time (s)") +
        scale_y_continuous(labels = comma) +
        facet_wrap(~variable, scales="free", ncol=1)
print(p5)

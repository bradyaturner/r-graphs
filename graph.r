#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)

data <- read.csv("stdin")

# make a copy of the data
d2 <- data

# get rid of date column
d2$date <- NULL

# get rid of record column TEMPORARY
d2$rec.hw.0 <- NULL

#Melt into long format with first column as the id variable
d2.m <- melt(d2, id.vars = 1)

p <- ggplot(d2.m, aes(timestamp,value, colour=variable)) + geom_line()

plot(p)

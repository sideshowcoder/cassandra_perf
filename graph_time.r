#!/usr/bin/env Rscript

f <- file("stdin")
Data <- read.csv(f, header=FALSE)

Count <- Data$V1
Time <- Data$V2

with(Data, plot(Count, Time, type = "l"))
with(Data, lines(Count, Time))

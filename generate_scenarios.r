library(mvtnorm)

set.seed(0)

alpha <- 1
beta <- 5
v <- 4
mu <- c(2.5, 1.5, 3.5)
sigma <- matrix(c(1, -2, -1, -2, 25, -8, -1, -8, 9), ncol=3, nrow=3)
count <- 20

samples <- list()
while (length(samples) < count) {
    sample <- mu + rmvt(1, sigma=sigma, df=v)
    if (min(sample) < alpha || max(sample) > beta) next
    samples <- append(samples, list(sample))
}

samples <- do.call(rbind, samples)
print(samples)
write.table(samples, 'scenarios.csv', sep=',', col.names=FALSE, row.names=FALSE)
library(mvtnorm)

set.seed(0)

alpha <- 1
beta <- 5
v <- 4
mu <- c(2.5, 1.5, 3.5)
sigma <- matrix(c(1, -2, -1, -2, 25, -8, -1, -8, 9), ncol=3, nrow=3)
count <- 20

sink("scenarios.dat")
cat("set SCENARIUSZE = 1:", count, ";\n\n", sep="")
cat("param koszt_dodatkowego_mw =\n")

scenario <- 1
while (scenario <= count) {
    sample <- mu + rmvt(1, sigma=sigma, df=v)
    if (min(sample) < alpha || max(sample) > beta) next
    cat("\t", scenario," ", sample[1]," ", sample[2], " ",sample[3], "\n", sep="")
    scenario <- scenario + 1
}

cat(";")
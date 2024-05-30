costs_0 <- read.csv("dystrybuanta_0.csv", sep='\t')$cost
costs_1000 <- read.csv("dystrybuanta_1000.csv", sep='\t')$cost
costs_2300 <- read.csv("dystrybuanta_2300.csv", sep='\t')$cost

costs_all <- c(costs_0, costs_1000, costs_2300)
xs <- seq(min(costs_all), max(costs_all), by=1)

filename <- "dystrybuanty.png"
png(filename, width = 200, height = 200, units='mm', res = 300)
plot(xs, ecdf(costs_0)(xs), type="l", xlab="Koszt [zł]", ylab="Prawdopodobieństwo", col="blue", lwd=3)
lines(xs, ecdf(costs_1000)(xs), type="l", col="green", lwd=3)
lines(xs, ecdf(costs_2300)(xs), type="l", col="red", lwd=3)
legend(x="topleft", legend=c("A, λ = 0", "B, λ = 1000", "C, λ = 2300"), col=c("blue", "green", "red"), lty=1, lwd=3)

dev.off()

system2("xdg-open", args=c(filename))
alpha <- 1
beta <- 5
v <- 4
mu <- c(2.5, 1.5, 3.5)
variance <- c(1, 25, 9)
stddev <- sqrt(variance) 

a <- (alpha - mu) / stddev
b <- (beta - mu) / stddev

expected <- mu + stddev * gamma((v-1)/2) * ((v+a^2)^(-(v-1)/2) - (v+b^2)^(-(v-1)/2)) * v^(v/2) / 2 / (pt(b, v) - pt(a, v)) / gamma(v/2) / gamma(1/2)
print(expected)
koszt_vs_mad <- read.csv("koszt_vs_mad.csv", sep='\t')

filename <- "cost_vs_risk.png"
png(filename, width = 200, height = 200, units='mm', res = 300)
plot(koszt_vs_mad$mad, koszt_vs_mad$koszt, pch=20, xlab="Ryzyko - odchylenie przeciętne [zł]", ylab="Średni koszt [zł]")

lambda_0 <- koszt_vs_mad[koszt_vs_mad$lambda == 0, ]
points(lambda_0$mad, lambda_0$koszt, pch=0, col="blue",cex=1.5)
text(lambda_0$mad, lambda_0$koszt, pos=3, labels="λ = 0", col="blue")

lambda_1000 <- koszt_vs_mad[koszt_vs_mad$lambda == 1000, ]
points(lambda_1000$mad, lambda_1000$koszt, pch=0, col="green",cex=1.5)
text(lambda_1000$mad, lambda_1000$koszt, pos=3, labels="λ = 1000", col="green")
text(lambda_1000$mad, lambda_1000$koszt, pos=1, labels=paste("(",round(lambda_1000$mad), ", ", round(lambda_1000$koszt),")", sep=""), col="black", cex=0.6)

lambda_2300 <- koszt_vs_mad[koszt_vs_mad$lambda == 2300, ]
points(lambda_2300$mad, lambda_2300$koszt, pch=0, col="red",cex=1.5)
text(lambda_2300$mad, lambda_2300$koszt, pos=3, labels="λ = 2300", col="red")
text(lambda_2300$mad, lambda_2300$koszt, pos=1, labels=paste("(",round(lambda_2300$mad), ", ", round(lambda_2300$koszt),")", sep=""), col="black", cex=0.6)

lambda_13600 <- koszt_vs_mad[koszt_vs_mad$lambda == 13600, ]
points(lambda_13600$mad, lambda_13600$koszt, pch=0, col="black",cex=1.5)
text(lambda_13600$mad, lambda_13600$koszt, pos=3, labels="        λ = 13600", col="black")

min_cost <- koszt_vs_mad[koszt_vs_mad$koszt == min(koszt_vs_mad$koszt), ]
text(min_cost$mad, min_cost$koszt, pos=1, labels=paste("(",round(min_cost$mad), ", ", round(min_cost$koszt),")          ", sep=""), col="black", cex=0.6)

min_risk <- koszt_vs_mad[koszt_vs_mad$mad == min(koszt_vs_mad$mad), ]
text(min_risk$mad, min_risk$koszt, pos=1, labels=paste("   (",round(min_risk$mad), ", ", round(min_risk$koszt),")", sep=""), col="black", cex=0.6)

dev.off()

system2("xdg-open", args=c(filename))
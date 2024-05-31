df <- read.csv("ryzyko-koszt.csv", sep = "\t")

filename <- "ryzyko-koszt.png"
png(filename, width = 200, height = 200, units = "mm", res = 300)
plot(df$ryzyko, df$koszt, pch = 20, xlab = "Ryzyko - odchylenie przeciętne [zł]", ylab = "Średni koszt [zł]")

lambda_0 <- df[df$lambda == 0, ]
points(lambda_0$ryzyko, lambda_0$koszt, pch = 0, col = "blue", cex = 1.5)
text(lambda_0$ryzyko, lambda_0$koszt, pos = 3, labels = "λ = 0", col = "blue")

lambda_1000 <- df[df$lambda == 1000, ]
points(lambda_1000$ryzyko, lambda_1000$koszt, pch = 0, col = "green", cex = 1.5)
text(lambda_1000$ryzyko, lambda_1000$koszt, pos = 3, labels = "λ = 1000", col = "green")
text(lambda_1000$ryzyko, lambda_1000$koszt, pos = 1, labels = paste("(", round(lambda_1000$ryzyko), ", ", round(lambda_1000$koszt), ")", sep = ""), col = "black", cex = 0.6)

lambda_2300 <- df[df$lambda == 2300, ]
points(lambda_2300$ryzyko, lambda_2300$koszt, pch = 0, col = "red", cex = 1.5)
text(lambda_2300$ryzyko, lambda_2300$koszt, pos = 3, labels = "λ = 2300", col = "red")
text(lambda_2300$ryzyko, lambda_2300$koszt, pos = 1, labels = paste("(", round(lambda_2300$ryzyko), ", ", round(lambda_2300$koszt), ")", sep = ""), col = "black", cex = 0.6)

lambda_13600 <- df[df$lambda == 13600, ]
points(lambda_13600$ryzyko, lambda_13600$koszt, pch = 0, col = "black", cex = 1.5)
text(lambda_13600$ryzyko, lambda_13600$koszt, pos = 3, labels = "        λ = 13600", col = "black")

min_cost <- df[df$koszt == min(df$koszt), ]
text(min_cost$ryzyko, min_cost$koszt, pos = 1, labels = paste("(", round(min_cost$ryzyko), ", ", round(min_cost$koszt), ")          ", sep = ""), col = "black", cex = 0.6)

min_risk <- df[df$ryzyko == min(df$ryzyko), ]
text(min_risk$ryzyko, min_risk$koszt, pos = 1, labels = paste("   (", round(min_risk$ryzyko), ", ", round(min_risk$koszt), ")", sep = ""), col = "black", cex = 0.6)

dev.off()

system2("xdg-open", args = c(filename))

require(ggplot2)
require(scales)

data <- read.csv("job satisfaction.csv", stringsAsFactors = F)
names(data) = c("Occupation", "Income", "Satisfaction")

data$Income <- as.numeric(data$Income)

overall.plot <- ggplot(data, aes(x=Income, y=Satisfaction)) + 
  geom_point() + 
  geom_smooth(formula = y ~ poly(x,2), method = "lm") + 
  scale_x_continuous(labels = comma)


ggsave(plot=overall.plot, filename="plots/overall_plot.svg", width = 10 , height = 7)


data$Predicted <- predict(lm(Satisfaction~poly(Income,2), data=data))
data$Difference <- data$Satisfaction - data$Predicted

difference.plot <- ggplot(data, aes(y=Difference, x=Income)) + 
  geom_point(size = 2) +
  geom_hline(yintercept = 0) + 
  scale_x_continuous(labels = comma)

ggsave(plot = difference.plot, filename = "plots/difference_plot.svg", width = 10, height = 7)

write.csv(data, "plot_data.csv", row.names = F)

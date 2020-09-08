# This R script will create the Talon status pic for website
library(gridExtra)
library(grid)
numR <- system("squeue  | awk -F\" \" '$5==\"R\"' | wc -l", intern = TRUE)
numPD <- system("squeue  | awk -F\" \" '$5==\"PD\"' | wc -l", intern = TRUE)
acc6320 <- 100.0 - as.numeric(system("./Talon3utilization.sh -c | tail -n+14 | tac | tail -n+2 | tac | awk '{print $5}' | head -n+1",intern =TRUE))
acc420 <- 100.0 - as.numeric(system("./Talon3utilization.sh -c | tail -n+14 | tac | tail -n+2 | tac | awk '{print $5}' | head -n+2 | tail -n+2",intern =TRUE))
acc720 <- 100.0 - as.numeric(system("./Talon3utilization.sh -c | tail -n+14 | tac | tail -n+2 | tac | awk '{print $5}' | head -n+3 | tail -n+3",intern =TRUE))
acc730 <- 100.0 - as.numeric(system("./Talon3utilization.sh -c | tail -n+14 | tac | tail -n+2 | tac | awk '{print $5}' | head -n+4 | tail -n+4",intern =TRUE))
t3stat <- data.frame("Talon3"=c("UP/Healthy", paste(numR , " Running / " , numPD , " Queued"),paste(acc6320,"%"),paste(acc420,"%"),paste(acc720,"%"),paste(acc730,"%")))
rownames(t3stat) <- c("System Status","Number of Jobs","Allocated C6320", "Allocated R420", "Allocated R720", "Allocated R730")
t3stat2 <- tableGrob(t3stat)
find_cell <- function(table, row, col, name="core-fg"){
 l <- table$layout
 which(l$t==row & l$l==col & l$name==name)
 }
ind <- find_cell(t3stat2, 2,2, "core-bg")
t3stat2$grobs[ind][[1]][["gp"]] <- gpar(fill="green")
png("t3stats.png",width = 350, height = 150, units = "px")
grid.draw(t3stat2)
dev.off()

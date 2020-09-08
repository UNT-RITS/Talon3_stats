# This R script will create the Talon status pic for website
library(gridExtra)
library(grid)
numR <- system("squeue  | awk -F\" \" '$5==\"R\"' | wc -l", intern = TRUE)
numPD <- system("squeue  | awk -F\" \" '$5==\"PD\"' | wc -l", intern = TRUE)
numacc <- 100.0 - as.numeric(system("a=`./Talon3utilization.sh -c | tail -n+14 | tac | tail -n+2 | tac | awk '{print $5}'` ; b=`echo 0` ; for c in $a ; do b=`echo \"$b + $c\" | bc -l` ; done ; total=`echo \"scale=1 ; $b / 4\" | bc -l`; echo $total",intern =TRUE))
t3stat <- data.frame("Talon3"=c("UP/Healthy", paste(numR , " Running / " , numPD , " Queued"),paste(numacc,"%")))
rownames(t3stat) <- c("System Status","Number of Jobs","Allocated Compute Resources")
t3stat2 <- tableGrob(t3stat)
find_cell <- function(table, row, col, name="core-fg"){  
 l <- table$layout 
 which(l$t==row & l$l==col & l$name==name) 
 }
ind <- find_cell(t3stat2, 2,2, "core-bg")
t3stat2$grobs[ind][[1]][["gp"]] <- gpar(fill="green")
png("t3stats.png",width = 350, height = 100, units = "px")
grid.draw(t3stat2)
dev.off()


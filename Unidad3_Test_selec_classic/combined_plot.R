rm(list=ls())
sweed <- read.table("SweeD_Report.ms1", header=TRUE)
omega <- read.table("OmegaPlus_Report.ms1", header=F)

sw <- sweed[,2]
om <- omega[,2]

#modify this to change significance cutoff
thr <- 0.1

assign.pvalues <- function(array){
  #array <- sample(sw, 1000)
  pvalues <- array(0, length(array))

  ordered.indexes <- order(array)
  
  j <- length(array)
  for( i in ordered.indexes ){
    pvalues[i] <- j/length(array)
    j <- j-1
  }

  return(pvalues)  
}


om.pval <- assign.pvalues(om)
sw.pval <- assign.pvalues(sw)
outliers <- which(om.pval < thr & sw.pval < thr)

postscript("figure3.eps", paper="special", onefile=FALSE, horizontal=F, width=6.5, height=5)

layout(matrix(c(1,2,3,3), 2, 2, byrow=F), widths=c(3.2,3), heights=c(2,2))

par(mar=c(4,4,1,0))

plot(sweed[,1], sw, col="darkgray", pch=16, ylab="", xlab="")
mtext(side=1, text="Position", 2)
mtext(side=2, text="SweeD", 2)
points(sweed[outliers,1], sw[outliers], col="red", pch=16, cex=1.2)
points(sweed[outliers,1], sw[outliers], col="black", pch=1, cex=1.2)
mtext(side=3, text="A", adj=0.5, 0.)

plot(sweed[,1], om, col="darkgray", pch=16, ylab="", xlab="")
mtext(side=1, text="Position", 2)
mtext(side=2, text="OmegaPlus", 2)
points(sweed[outliers,1], om[outliers], col="red", pch=16, cex=1.2)
points(sweed[outliers,1], om[outliers], col="black", pch=1, cex=1.2)


#pdf("join_plot_sweed_omega.pdf")
#png("join_plot_sweed_omega.png")
plot(sw, om, main="", xlab="", ylab="",axes=F)
mtext(side=1, text="SweeD", 2)
mtext(side=2, text="OmegaPlus", 2)

points(sw[outliers], om[outliers], col="red", pch=16)
axis(side=1)
axis(side=2)
mtext(side=3, text="B", adj=0.5, 0.)
dev.off()

## string <- paste("chr1:",sweed[outliers,1]-5000, "..", sweed[outliers,1]+5000, sep="")
## write.table(string, "", quote=F, row.names=F, col.names=F)

annot <- read.table("Genes_July_2010_hg19.gff")

positions <- sweed[outliers,1]

get.gene <- function(i, chr){

  chr.annot <- annot[which(annot[,1] == chr), ]
  
  min.ind1 <- which.min( abs( positions[i]-chr.annot[,4] ) )
  min.ind2 <- which.min(abs( positions[i]-chr.annot[,5] ) )

  if(min.ind1 == min.ind2){
    return(annot[min.ind1, 9])
  }

  if( abs(positions[i]-chr.annot[min.ind1,4]) < abs(positions[i]-chr.annot[min.ind2,5]) ){
    return(chr.annot[min.ind1, 9])
  }

  return(chr.annot[min.ind2, 9])
}

gene <- array(NA, length(positions)) 
for( i in 1:length(positions) ){
  
  gene.string <- get.gene( i, "chr1" )
  
  gene[i] <- strsplit(strsplit( as.character(gene.string), split=";")[[1]][3], "=")[[1]][2]
}

write.table(data.frame(gene, omega[outliers, 2], sweed[outliers, 2]), "outlier_genes.txt", sep="\t", quote=F, row.names=F, col.names=F)



write(gene, ncolumns=2, "", sep="\t")

# correlation coefficient sw - ome

cor.test(sw, om)

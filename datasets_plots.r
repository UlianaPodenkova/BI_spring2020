setwd("C:/R")
#Firstly we formed datasets with certain serotypes
'%notin%'<- Negate('%in%')
data <- read.csv('data1.csv', sep=";")
head(data)
a <- c('19F', '3', '23F','7F', '1', '14')
new_data <- data[(data$serotype %in% a) & (data$diagnosis %notin% c('carriage','carrier')),]
levels(new_data$diagnosis)
str(new_data)
write.csv(new_data, file = "filtered_dataset.csv")
isolate <- data.frame(table(new_data$ST..MLST.))
head(isolate)
str(isolate)
isolate <- isolate[which(isolate$Freq>7),]
nrow(new_data)
n <- colnames(new_data[,9:ncol(new_data)])
n
new_data <- data.frame(new_data)

library(ggplot2)

for(i in colnames(new_data[,9:ncol(new_data)])){
  print(i)
  ggplot(data = new_data, aes(x=i, fill=as.factor(ST..MLST.)))+geom_histogram(stat="count")
  ggsave(paste(i,".png"),device="png")
  #dev.off()
}


ggplot(new_data, aes(country))
geom_histogram()

qplot(x=year, y=ST..MLST.,size=18,color=factor(ST..MLST.), data=new_data)
qplot(x=continent,fill=as.factor(ST..MLST.),data=new_data)

qplot(x=year,color=as.factor(ST..MLST.),data=new_data, geom=hist)


#table with the number of strains in each sequence type
md <- as.data.frame(table(new_data$ST..MLST.))
STs <- md[which(md$Freq>5),"Var1"]

df <- new_data[which(new_data$ST..MLST. %in% STs),]

qplot(x=year,color=as.factor(ST..MLST.),data=df, labs(color='NEW LEGEND TITLE')
)

#some plots
ggplot(data= df,aes(x=year,fill=as.factor(ST..MLST.)))+geom_histogram(stat="count")+ylab('ST_MLST')+guides(fill=guide_legend(title="ST_MLST"))


ggplot(data= df,aes(x=continent,fill=as.factor(ST..MLST.)))+geom_histogram(stat="count")+ylab('ST_MLST')+guides(fill=guide_legend(title="ST_MLST"))

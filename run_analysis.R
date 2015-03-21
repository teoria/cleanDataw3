library(dplyr)

# Load data sets and merge
colunas  <- read.table(file = "./UCI HAR Dataset/features.txt")
activity_labels  <- read.table(file = "./UCI HAR Dataset/activity_labels.txt")


trainSet <- read.table(file = "./UCI HAR Dataset/train/X_train.txt")
trainSubj <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt")
trainAct <- read.table(file = "./UCI HAR Dataset/train/y_train.txt")

trainSet <- mutate(trainSet, activity_labels = factor(trainAct$V1))
trainSet <- mutate(trainSet, subject = factor(trainSubj$V1))

testSet <- read.table(file = "./UCI HAR Dataset/test/X_test.txt")
testSubj <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt")
testAct <- read.table(file = "./UCI HAR Dataset/test/y_test.txt")

testSet <- mutate(testSet, activity_labels = factor(testAct$V1))
testSet <- mutate(testSet, subject = factor(testSubj$V1))

dat <- merge(trainSet,testSet , all=T)

names(dat) <- colunas$V2


# subset only mean or std columns
colunasB <- grepl("mean\\(\\)|std\\(\\)" , colunas$V2 );

dados <- dat[ ,colunasB ]

names(dados)[dim(dados)[2]-1] <- "activity"
names(dados)[dim(dados)[2]] <- "subject"
 
# merge activity labels
tidyDat <- merge(dados,activity_labels, by.x = "activity" , by.y = "V1", all=T)
tidyDat[1]<-NULL
names(tidyDat)[dim(tidyDat)[2]] <- "activity"


# summarise dataset group by activity and subject
temp <-tidyDat %>% group_by(activity,subject) 
resultado <- summarise_each(temp,funs(mean))

# save output
write.table(resultado,"result.txt" ,row.names = FALSE)
 

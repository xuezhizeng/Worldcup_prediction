���籭���Ԥ��
========================================================
By Casper

Just for fun

����˼·�����籭�����������ݱ����·����ʼΪ����������Ԥ�⣬Ԥ��ķ������ֶ���
�����ǻ����ɷ�Ϊ����������ԱΪ�����Ļ�������֪ʶԤ�⣬�Լ��������Ϊ�����������
Ԥ�⡣���Ĳ��õ��ǻ���ѧϰ�ķ���������ʷ���籭������Ϊtraining data������̭������
����ʤ��ΪԤ�����С��������ΪԤ�����ӣ��������ģ�ͣ����Ͻ�������������Ϊ
validation��ɸѡ������ģ�ͣ��Ա������籭����̭���������Ԥ�⣬���������Kaggle��
March Machine Learning Mania������NCAA�����Ԥ��


����Ԥ����ͼ

![title](path/to/your/image)


## 1. Getting the data
������ԴΪFIFA������ץȡ1966-2010��ʮһ�����籭����ʷ������ҳ��ͨ������html�ļ���
��ð���С����ʤ��������������ƽ������������������������������Ϣ���ٽ����̭����
ʤ����������ɱ���

![fifa_web](fifa_web��ͼ.png)


```r
library(XML)
Url_2010 <- "http://www.fifa.com/tournaments/archive/worldcup/southafrica2010/matches/index.html"
Url_2006 <- "http://www.fifa.com/tournaments/archive/worldcup/germany2006/matches/index.html"
Url_2002 <- "http://www.fifa.com/tournaments/archive/worldcup/koreajapan2002/matches/index.html"
Url_1998 <- "http://www.fifa.com/tournaments/archive/worldcup/france1998/matches/index.html"
Url_1994 <- "http://www.fifa.com/tournaments/archive/worldcup/usa1994/matches/index.html"
Url_1990 <- "http://www.fifa.com/tournaments/archive/worldcup/italy1990/matches/index.html"
Url_1986 <- "http://www.fifa.com/tournaments/archive/worldcup/mexico1986/matches/index.html"
Url_1982 <- "http://www.fifa.com/tournaments/archive/worldcup/spain1982/matches/index.html"
Url_1978 <- "http://www.fifa.com/tournaments/archive/worldcup/argentina1978/matches/index.html"
Url_1974 <- "http://www.fifa.com/tournaments/archive/worldcup/germany1974/matches/index.html"
Url_1970 <- "http://www.fifa.com/tournaments/archive/worldcup/mexico1970/matches/index.html"
Url_1966 <- "http://www.fifa.com/tournaments/archive/worldcup/england1966/matches/index.html"

web_2010 <- htmlTreeParse(Url_2010, useInternal=TRUE)
```



## 2. Clean the data
### 2.1 ��2010�����籭���Ϊtesting dataset

���С�������

```r
score_2010 <- xpathSApply(web_2010, "//td[@class='c']", xmlValue)
team_name <- xpathSApply(web_2010, "//td[@class='l']", xmlValue)
```

���ݱ��񿴳���7������

```r
gpresult_2010_1 <- matrix(score_2010, ncol=7, byrow=TRUE) 
gpresult_2010_2 <- cbind(team_name, gpresult_2010_1)
colnames(gpresult_2010_2) <- c("Team", "Played", "Won", "Draw", "Lost", 
"Goals For", "Goals Against", "Points")
```

�����̭�������С��������48������̭��16������64����������Ҫ��49-64��������

```r
home_team <- xpathSApply(web_2010, "//td[@class='l homeTeam']", 
                         xmlValue)[49:64]
away_team <- xpathSApply(web_2010, "//td[@class='r awayTeam']",
                         xmlValue)[49:64]
```


```r
##ע����̭���еĽ��ֻ�и��ݱȷ����б�ȡ��49-64���ıȷ����ݣ�Node��
##<td style="width:120px" class="c ">�� c�������һ���ո�
result <- xpathSApply(web_2010, "// td[@class='c ']", xmlValue)[49:64]
```


���ݱȷֽ���ʤ����������������ǵ�������PSO��ʾ�����ս���ж������û�е����
ʤ��ÿ��ĵ�һ��Ԫ��Ϊʤ�����ݣ�����е����ʤ��������Ԫ����Ϊ����

```r
result1 <- as.character(result)
split <- strsplit(result1," ")
result2 <- list()
for (i in 1:16){
    if (regexpr("PSO", result1[[i]])>0){
       result2[i] <- split[[i]][length(split[[i]])-1] 
    }
    else{
        result2[i] <- split[[i]][1]
    }
}

split1 <- strsplit(as.character(result2),":")
result3 <- list()
for (i in 1:16){
    if (split1[[i]][1]>split1[[i]][2]){
       result3[i]=1 
    }
    else{
        result3[i]=0
    }
}

eliresult_2010 <- data.frame(home_team=home_team, away_team=away_team, 
                             result=result,result3=as.numeric(result3))
```

���С��������̭�����ݣ���team��Ϊindex

![�������](�������.png)


```r
final_result_2010 <- merge(eliresult_2010, gpresult_2010_2, by.x="home_team", 
                      by.y="Team", sort=TRUE)                                                             
final_result_2010 <- merge(final_result_2010, gpresult_2010_2, by.x="away_team", 
                      by.y="Team", sort=FALSE)
final_result_2010 <- data.frame(final_result_2010[,2], final_result_2010[,1],
                                final_result_2010[,4:18])

final_result_2010[18] <- "2010"
colnames(final_result_2010) <- c("Home", "Away", "Result", "Played_Home", 
                                 "Won_Home", "Draw_Home", "Lost_Home", 
                                 "Goals_For_Home", "Goals_Against_Home", 
                                 "Point_Home","Played_Away", "Won_Away",
                                 "Draw_Away", "Lost_Away", "Goals_For_Away",
                                 "Goals_Against_Away", "Point_Away", "Year")
write.csv(final_result_2010,"./test.csv")
```


### 2.2 ��1966-2006�����籭���Ϊtraining dataset
���й����з���һЩ���⣬1998-2010�����籭�Ĳ�������Ϊ32֧������Ϊ64����������̭
��Ϊ��49-64����1982-1994���������Ϊ24֧������Ϊ52����������̭��Ϊ��37-52����1966-1978���������Ϊ16֧������Ϊ38���������������⣬78����ǰС������Ϊ���֣���һ�ֽ����ģ�����ڶ���С�������������������֣�����޷�����С������Ϣ��Ϊ��̭����Ԥ�����أ����training dataֻ����1982-2006������ݡ� %>_<%

����function���Դ���testing data�ķ���������training dataset

```r
create_train_data <- function(Url){
    
    web <- htmlTreeParse(Url, useInternal=TRUE)
    year <- substr(Url, nchar(Url)-22, nchar(Url)-19)
    
    if (Url%in%c(Url_2006, Url_2002, Url_1998)){
        emi_index <- 49:64
    }
    else if (Url%in%c(Url_1994, Url_1990, Url_1986)){
        emi_index <- 37:52
    }
         
    score <- xpathSApply(web, "//td[@class='c']", xmlValue)
    team_name <- xpathSApply(web, "//td[@class='l']", xmlValue)
    
    gpresult_1 <- matrix(score, ncol=7, byrow=TRUE) 
    gpresult_2 <- cbind(team_name, gpresult_1)
    colnames(gpresult_2) <- c("Team", "Played", "Won", "Draw", "Lost", 
                                   "Goals For", "Goals Against", "Points")
    
    home_team <- xpathSApply(web, "//td[@class='l homeTeam']", 
                             xmlValue)[emi_index]
    away_team <- xpathSApply(web, "//td[@class='r awayTeam']",
                             xmlValue)[emi_index]
    
    result <- xpathSApply(web, "// td[@class='c ']", xmlValue)[emi_index]

    result1 <- as.character(result)
    split <- strsplit(result1," ")
    result2 <- list()
    for (i in 1:16){
        if (regexpr("PSO", result1[[i]])>0){
            result2[i] <- split[[i]][length(split[[i]])-1] 
        }
        else{
            result2[i] <- split[[i]][1]
        }
    }
    
    split1 <- strsplit(as.character(result2),":")
    result3 <- list()
    for (i in 1:16){
        if (split1[[i]][1]>split1[[i]][2]){
            result3[i]=1 
        }
        else{
            result3[i]=0
        }
    }
    
    eliresult <- data.frame(home_team=home_team, away_team=away_team, 
                                 result=result,result3=as.numeric(result3))
    
    final_result <- merge(eliresult, gpresult_2, by.x="home_team", 
                               by.y="Team", sort=TRUE)                                                             
    final_result <- merge(final_result, gpresult_2, by.x="away_team", 
                               by.y="Team", sort=FALSE)
    final_result <- data.frame(final_result[,2], final_result[,1],
                               final_result[,4:18])
    
    final_result[18] <- year
    
    colnames(final_result) <- c("Home", "Away", "Result", "Played_Home", 
                                "Won_Home", "Draw_Home", "Lost_Home", 
                                "Goals_For_Home", "Goals_Against_Home", 
                                "Point_Home", "Played_Away", "Won_Away", 
                                "Draw_Away", "Lost_Away", "Goals_For_Away", 
                                "Goals_Against_Away", "Point_Away", "Year")
    filename=paste("training","_", year, sep="")
    write.csv(final_result, paste(filename,".csv",
                                  sep=""))
    
}

Whole_Url <- c(Url_2006, Url_2002, Url_1998, Url_1994, Url_1990, Url_1986)

for (i in 1:6){
    create_train_data(Whole_Url[i])
}

training_1986 <- read.csv("./training_1986.csv")
training_1990 <- read.csv("./training_1990.csv")
training_1994 <- read.csv("./training_1994.csv")
training_1998 <- read.csv("./training_1998.csv")
training_2002 <- read.csv("./training_2002.csv")
training_2006 <- read.csv("./training_2006.csv")

training <- rbind(training_1986, training_1990, training_1994, training_1998,
                  training_2002, training_2006)

write.csv(training, "training.csv")
```


## 3. Data Analysis

```r
test <- read.csv("test.csv")

train_data <- data.frame(Result=as.factor(training$Result), 
                         Played_Home=as.numeric(training$Played_Home),
                         Won_Home=as.numeric(training$Won_Home),
                         Draw_Home=as.numeric(training$Draw_Home),
                         Lost_Home=as.numeric(training$Lost_Home),
                         Goals_For_Home=as.numeric(training$Goals_For_Home),
                         Goals_Against_Home=as.numeric(training$Goals_Against_Home),
                         Point_Home=as.numeric(training$Point_Home),
                         Played_Away=as.numeric(training$Played_Away),
                         Won_Away=as.numeric(training$Won_Away),
                         Draw_Away=as.numeric(training$Draw_Away),
                         Lost_Away=as.numeric(training$Lost_Away),
                         Goals_For_Away=as.numeric(training$Goals_For_Away),
                         Goals_Against_Away=as.numeric(training$Goals_Against_Away),
                         Point_Away=as.numeric(training$Point_Away))
```

### 3.1 ��SVD����ĸ����ضԽ��Ӱ�����

```r
svd1 <- svd(train_data[,c(3,4,6,7,10,11,13,14)])
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

���Կ������������еĹ����Էǳ����أ�����ԭ�����£�ÿ�ӵĳ�������һ���ģ�ʤ��ƽ��
����������һ���ģ�ʤ�����ȷ���Ժ����Ҳ��һ���ģ���ˣ���Ҫ�ų�������"Played"��������"Lost_Home"��"Lost_Away"���Լ�С�����"Point_Home"��"Point_Away"

��train_data����prediction model����test����ģ��ɸѡ

### 3.2 Try Logistic Regression Model

```r
fit_LR <- glm(Result ~ Won_Home + Goals_For_Home 
              + Goals_Against_Home + Point_Home + Won_Away + Draw_Away 
              + Goals_For_Away + Goals_Against_Away, data=train_data, 
              family= "binomial")

prediction_LR <- predict(fit_LR, test)
prediction_LR[prediction_LR<0.5] <- 0
prediction_LR[prediction_LR>=0.5] <- 1
```

### 3.3 Try Decision Tree Model

```r
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(rpart)

fit_DT <- rpart(Result ~ Won_Home + Goals_For_Home 
                + Goals_Against_Home + Point_Home + Won_Away + Draw_Away 
                + Goals_For_Away + Goals_Against_Away, data=train_data, 
                method="class")

prediction_DT <- predict(fit_DT, test, type="class")


fancyRpartPlot(fit_DT)
```

```
## Warning: conversion failure on 'Rattle 2014-六月-11 16:16:26 huangshan' in 'mbcsToSbcs': dot substituted for <e5>
## Warning: conversion failure on 'Rattle 2014-六月-11 16:16:26 huangshan' in 'mbcsToSbcs': dot substituted for <85>
## Warning: conversion failure on 'Rattle 2014-六月-11 16:16:26 huangshan' in 'mbcsToSbcs': dot substituted for <ad>
## Warning: conversion failure on 'Rattle 2014-六月-11 16:16:26 huangshan' in 'mbcsToSbcs': dot substituted for <e6>
## Warning: conversion failure on 'Rattle 2014-六月-11 16:16:26 huangshan' in 'mbcsToSbcs': dot substituted for <9c>
## Warning: conversion failure on 'Rattle 2014-六月-11 16:16:26 huangshan' in 'mbcsToSbcs': dot substituted for <88>
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 

### 3.4 Try Random Forest Model

```r
library(randomForest)
fit_RF <- randomForest(Result ~ Won_Home + Goals_For_Home 
                       + Goals_Against_Home + Point_Home + Won_Away + Draw_Away 
                       + Goals_For_Away + Goals_Against_Away, data=train_data, 
                       importance=TRUE, ntree=100)
prediction_RF <- predict(fit_RF, test)
```

����Ƚ���Ϊtraining data���Ƚ�С��Ϊ�˱������overfit�����ǲ���Logistic Regression Model

```r
model_check <- data.frame(test$Result, prediction_LR, prediction_DT, 
                          prediction_RF)
```

## 4. Result


## 5. Future Work
�������������籭��ʷ������Ϊtraining data����С��������ΪPredictor������̭�����ΪOutput����Logistic Regression, Decision Tree��Random Forest����ģ����ɸѡ�˶�test data�����õ�Logistic Regression���ڽ������籭��С������������Ϊ��̭����Ԥ�⡣

���Ǳ�Ԥ��Ҳ�кܶ�������Ҫ��������ȣ�training data�������ز��㣬������Ϊ���籭��
ʷ�������Ƚ�С���Ժ����������ŷ�ޱ������ޱ�������̭���ı�����Ϊtraining����Σ�
Variablesƫ�٣������Variables���������أ�������ĽǶ����������Բο���Predictor�п����ʣ������������������������ȵȡ�
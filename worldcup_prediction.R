## ===============================By Casper===================================
## =============================Just for fun==================================

## ����˼·�����籭�����������ݱ����·����ʼΪ����������Ԥ�⣬Ԥ��ķ�������
## ���������ǻ����ɷ�Ϊ����������ԱΪ�����Ļ�������֪ʶԤ�⣬�Լ��������Ϊ����
## �������Ԥ�⡣���Ĳ��õ��ǻ���ѧϰ�ķ���������ʷ���籭������Ϊtraining data��
## ����̭�����ӱ���ʤ��ΪԤ�����С��������ΪԤ�����ӣ��������ģ�ͣ����Ͻ���
## ����������Ϊvalidation��ɸѡ������ģ�ͣ��Ա������籭����̭���������Ԥ�⣬��
## ��������Kaggle��March Machine Learning Mania������NCAA�����Ԥ��

## ����Ԥ����ͼ


## 1. Getting the data
## ������ԴΪFIFA������ץȡ1966-2010��ʮһ�����籭����ʷ������ҳ��ͨ������html��
## ������ð���С����ʤ��������������ƽ������������������������������Ϣ���ٽ��
## ��̭����ʤ����������ɱ���

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


## ����htmlͼƬ

## 2. Clean the data

## ��2010�����籭���Ϊtesting dataset

## ���С�������
score_2010 <- xpathSApply(web_2010, "//td[@class='c']", xmlValue)
team_name <- xpathSApply(web_2010, "//td[@class='l']", xmlValue)

##���ݱ��񿴳���7������
gpresult_2010_1 <- matrix(score_2010, ncol=7, byrow=TRUE) 
gpresult_2010_2 <- cbind(team_name, gpresult_2010_1)
colnames(gpresult_2010_2) <- c("Team", "Played", "Won", "Draw", "Lost", 
"Goals For", "Goals Against", "Points")

## С��������������һ���ģ�����ʤ����ƽ�ֿ��Լ���������ͻ��֣����Ϊ�˷�ֹ����
## �Բ����ĸ��ţ��ų�"Played",��Lost"��"Points"����
## gpresult_2010_3 <- gpresult_2010_2[,c(1,3,4,6,7)]

## �����̭�������С��������48������̭��16������64����������Ҫ��49-64��������
home_team <- xpathSApply(web_2010, "//td[@class='l homeTeam']", 
                         xmlValue)[49:64]
away_team <- xpathSApply(web_2010, "//td[@class='r awayTeam']",
                         xmlValue)[49:64]

## ע����̭���еĽ��ֻ�и��ݱȷ����б�ȡ��49-64���ıȷ����ݣ�
## Node��<td style="width:120px" class="c ">�� c�������һ���ո�
result <- xpathSApply(web_2010, "// td[@class='c ']", xmlValue)[49:64]


## ���ݱȷֽ���ʤ����������������ǵ�������PSO��ʾ�����ս���ж������û�е���
## ��ʤ��ÿ��ĵ�һ��Ԫ��Ϊʤ�����ݣ�����е����ʤ��������Ԫ����Ϊ����
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

## ���С��������̭�����ݣ���team��Ϊindex
final_result_2010 <- merge(eliresult_2010, gpresult_2010_2, by.x="home_team", 
                      by.y="Team", sort=TRUE)                                                             
final_result_2010 <- merge(final_result_2010, gpresult_2010_2, by.x="home_team", 
                      by.y="Team", sort=TRUE)
final_result_2010 <- final_result_2010[,-3]
final_result_2010[17] <- "2010"
colnames(final_result_2010) <- c("Home", "Away", "Result", "Played", "Won_Home",
                                 "Draw_Home", "Lost_Home", "Goals_For_Home",
                                 "Goals_Against_Home", "Point_Home","Won_Away",
                                 "Draw_Away", "Lost_Away", "Goals_For_Away",
                                 "Goals_Against_Away", "Point_Away", "Year")
write.csv(final_result_2010,"./worldcup_prediction/test.csv")

## ��1966-2006�����籭���Ϊtraining dataset�����й����з���һЩ���⣬1998-2010
## �����籭�Ĳ�������Ϊ32֧������Ϊ64����������̭��Ϊ��49-64����1982-1994�����
## ����Ϊ24֧������Ϊ52����������̭��Ϊ��37-52����1966-1978���������Ϊ16֧����
## ��Ϊ38���������������⣬78����ǰС������Ϊ���֣���һ�ֽ����ģ�����ڶ���С��
## �����������������֣�����޷�����С������Ϣ��Ϊ��̭����Ԥ�����أ����training
## dataֻ����1982-2006������ݡ� %>_<%

## ����function���Դ���testing data�ķ���������training dataset
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
    final_result <- merge(final_result, gpresult_2, by.x="home_team", 
                               by.y="Team", sort=TRUE)
    final_result <- final_result[,-3]
    
    final_result[17] <- year
    colnames(final_result) <- c("Home", "Away", "Result", "Played", "Won_Home", 
                                "Draw_Home", "Lost_Home", "Goals_For_Home", 
                                "Goals_Against_Home", "Point_Home",
                                "Won_Away", "Draw_Away", "Lost_Away", 
                                "Goals_For_Away", "Goals_Against_Away", 
                                "Point_Away", "Year")
    filename=paste("training","_", year, sep="")
    write.csv(final_result, paste("./worldcup_prediction/",filename,".csv",
                                  sep=""))
    
}

Whole_Url <- c(Url_2006, Url_2002, Url_1998, Url_1994, Url_1990, Url_1986)

for (i in 1:6){
    create_train_data(Whole_Url[i])
}

training_1986 <- read.csv("./worldcup_prediction/training_1986.csv")
training_1990 <- read.csv("./worldcup_prediction/training_1990.csv")
training_1994 <- read.csv("./worldcup_prediction/training_1994.csv")
training_1998 <- read.csv("./worldcup_prediction/training_1998.csv")
training_2002 <- read.csv("./worldcup_prediction/training_2002.csv")
training_2006 <- read.csv("./worldcup_prediction/training_2006.csv")

training <- rbind(training_1986, training_1990, training_1994, training_1998,
                  training_2002, training_2006)

write.csv(training, "./worldcup_prediction/training.csv")



## 3. Data Analysis
## SVD

svd1 <- svd(training[,5:12])
par(mfrow = c(1, 2))
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Prop. of variance explained",
     pch = 19)






library(rpart)





fit <- rpart(Result ~ Won_Home + Draw_Home + Goals_For_Home + Goals_Against_Home
             + Won_Away + Draw_Away + Goals_For_Away + Goals_Against_Away, data=
            training, method="class")


fit <- randomForest(as.factor(Result) ~ Won_Home + Draw_Home + Goals_For_Home + 
                    Goals_Against_Home + Won_Away + Draw_Away + Goals_For_Away +
                    Goals_Against_Away, data=training, importance=TRUE, 
                    ntree=2000)

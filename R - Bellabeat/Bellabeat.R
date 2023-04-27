setwd('C:/Users/Matheus/Desktop/Fitabase Data 4.12.16-5.12.16/')

#Instalar e Carregar pacotes necessários para a análise

install.packages('tidyverse')
install.packages('lubridate')
install.packages('cowplot')


library(tidyverse)
library(lubridate)
library(cowplot)


#Carregar fontes de dados

dailyActivity <- read_csv('C:/Users/Matheus/Desktop/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv')
sleepDay <- read_csv('C:/Users/Matheus/Desktop/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv')

###Exploração inicial das fontes de dados para identificar estrutura, organização, integridade, confiabilidade, viés, privacidade etc
###Os dataframes que contém nos nome 'daily' e 'hour' são diferentes agregações em menor escala e a princípio não serão usados como base principal para análise
###Os demais dataframes não serão utilizados na análise

###dados agregados de atividade diária
head(dailyActivity)
colnames(dailyActivity)

###dataframes que não está agregados ao dailyActiivity
head(sleepDay)
colnames(sleepDay)

#Transformação de Limpeza dos dados

##dailyActivity

str(dailyActivity)
dim(dailyActivity)
head(dailyActivity)
tail(dailyActivity)
glimpse(dailyActivity)
summary(dailyActivity)

table(is.na(dailyActivity))

dailyActivity$Id <- as.character(dailyActivity$Id)
dailyActivity$ActivityDate <- as.Date(dailyActivity$ActivityDate, "%m/%d/%y")
dailyActivity$TotalSteps <- as.integer(dailyActivity$TotalSteps)
dailyActivity$VeryActiveMinutes <- as.integer(dailyActivity$VeryActiveMinutes)
dailyActivity$FairlyActiveMinutes <- as.integer(dailyActivity$FairlyActiveMinutes)
dailyActivity$LightlyActiveMinutes <- as.integer(dailyActivity$LightlyActiveMinutes)
dailyActivity$SedentaryMinutes <- as.integer(dailyActivity$SedentaryMinutes)
dailyActivity$Calories <- as.integer(dailyActivity$Calories)

table(is.na(dailyActivity))
glimpse(dailyActivity)

write_csv(dailyActivity, 'Limpos/clean_dailyActivity.csv')

##sleepDay

str(sleepDay)
dim(sleepDay)
head(sleepDay)
tail(sleepDay)
glimpse(sleepDay)
summary(sleepDay)

table(is.na(sleepDay))

sleepDay$Id <- as.character(sleepDay$Id)
sleepDay$SleepDay <- as.Date(sleepDay$SleepDay, "%m/%d/%y")
sleepDay$TotalSleepRecords <- as.integer(sleepDay$TotalSleepRecords)
sleepDay$TotalMinutesAsleep <- as.integer(sleepDay$TotalMinutesAsleep)
sleepDay$TotalTimeInBed <- as.integer(sleepDay$TotalTimeInBed)

table(is.na(sleepDay))
glimpse(sleepDay)

write_csv(sleepDay, 'Limpos/clean_sleepDay.csv')

ggplot(data = sleepDay) +
  geom_point(mapping = aes(x = TotalMinutesAsleep, y = TotalTimeInBed))


#Tratamento de Outliers - Normalização

install.packages('outliers')
install.packages('psych')

library(psych)
library(outliers)



##Dataframe sleepDay

glimpse(sleepDay)

###TotalMinutesAsleep

summary(sleepDay$TotalMinutesAsleep)
hist(sleepDay$TotalMinutesAsleep)
boxplot(sleepDay$TotalMinutesAsleep)

### Nullify outliers 
sleepDay <- within(sleepDay, {
  TotalMinutesAsleep_1 <- ifelse(TotalMinutesAsleep %in% boxplot.stats(TotalMinutesAsleep)$out, NA, TotalMinutesAsleep)})

### Impute outliers with mean
sleepDay <- within(sleepDay, {TotalMinutesAsleep_1 <- ifelse(is.na(TotalMinutesAsleep_1), mean(TotalMinutesAsleep, na.rm = TRUE), TotalMinutesAsleep)})
                     

glimpse(sleepDay$TotalMinutesAsleep)
sleepDay$TotalMinutesAsleep_1 <- as.integer(sleepDay$TotalMinutesAsleep_1)

summary(sleepDay[c("TotalMinutesAsleep","TotalMinutesAsleep_1")])

h <- ggplot(sleepDay) +
  geom_histogram(binwidth = 50, mapping = aes(TotalMinutesAsleep)) + theme_bw()
h0 <- ggplot(sleepDay) +
  geom_histogram(binwidth = 50, mapping = aes(TotalMinutesAsleep_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(sleepDay) +
  geom_boxplot(mapping = aes(x = "", y = TotalMinutesAsleep)) + theme_bw()
bx0 <- ggplot(sleepDay) +
  geom_boxplot(mapping = aes(x = "", y = TotalMinutesAsleep_1)) + theme_bw()

plot_grid(bx,bx0)



###TotalTimeInBed

summary(sleepDay$TotalTimeInBed)
hist(sleepDay$TotalTimeInBed)
boxplot(sleepDay$TotalTimeInBed)

### Nullify outliers 
sleepDay <- within(sleepDay, {
  TotalTimeInBed_1 <- ifelse(TotalTimeInBed %in% boxplot.stats(TotalTimeInBed)$out, NA, TotalTimeInBed)})

### Impute outliers with mean
sleepDay <- within(sleepDay, {TotalTimeInBed_1 <- ifelse(is.na(TotalTimeInBed_1), mean(TotalTimeInBed, na.rm = TRUE), TotalTimeInBed)})

glimpse(sleepDay$TotalTimeInBed_1)
sleepDay$TotalTimeInBed_1 <- as.integer(sleepDay$TotalTimeInBed_1)


summary(sleepDay[c("TotalTimeInBed","TotalTimeInBed_1")])

h <- ggplot(sleepDay) +
  geom_histogram(binwidth = 50, mapping = aes(TotalTimeInBed)) + theme_bw()
h0 <- ggplot(sleepDay) +
  geom_histogram(binwidth = 50, mapping = aes(TotalTimeInBed_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(sleepDay) +
  geom_boxplot(mapping = aes(x = "", y = TotalTimeInBed)) + theme_bw()
bx0 <- ggplot(sleepDay) +
  geom_boxplot(mapping = aes(x = "", y = TotalTimeInBed_1)) + theme_bw()

plot_grid(bx,bx0)

write_csv(sleepDay, 'Limpos/clean_outliers_sleepDay.csv')

##############################################################################

##Dataframe dailyActivity

glimpse(dailyActivity)


###TotalSteps

summary(dailyActivity$TotalSteps)
hist(dailyActivity$TotalSteps)
boxplot.stats(dailyActivity$TotalSteps)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  TotalSteps_1 <- ifelse(TotalSteps %in% boxplot.stats(TotalSteps)$out, NA, TotalSteps)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {TotalSteps_1 <- ifelse(is.na(TotalSteps_1), mean(TotalSteps, na.rm = TRUE), TotalSteps)})

dailyActivity$TotalSteps_1 <- as.integer(dailyActivity$TotalSteps_1)

summary(dailyActivity[c("TotalSteps","TotalSteps_1")])

h <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 1000, mapping = aes(TotalSteps)) + theme_bw()
h0 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 1000, mapping = aes(TotalSteps_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = TotalSteps)) + theme_bw()
bx0 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = TotalSteps_1)) + theme_bw()

plot_grid(bx,bx0)



###VeryActiveDistance

summary(dailyActivity$VeryActiveDistance)
hist(dailyActivity$VeryActiveDistance)
boxplot.stats(dailyActivity$VeryActiveDistance)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  VeryActiveDistance_1 <- ifelse(VeryActiveDistance %in% boxplot.stats(VeryActiveDistance)$out, NA, VeryActiveDistance)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {VeryActiveDistance_1 <- ifelse(is.na(VeryActiveDistance_1), mean(VeryActiveDistance, na.rm = TRUE), VeryActiveDistance)})

summary(dailyActivity[c("VeryActiveDistance","VeryActiveDistance_1")])

h <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 1, mapping = aes(VeryActiveDistance)) + theme_bw()
h0 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 1, mapping = aes(VeryActiveDistance_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = VeryActiveDistance)) + theme_bw()
bx0 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = VeryActiveDistance_1)) + theme_bw()

plot_grid(bx,bx0)


###ModeratelyActiveDistance

summary(dailyActivity$ModeratelyActiveDistance)
hist(dailyActivity$ModeratelyActiveDistance)
boxplot.stats(dailyActivity$ModeratelyActiveDistance)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  ModeratelyActiveDistance_1 <- ifelse(ModeratelyActiveDistance %in% boxplot.stats(ModeratelyActiveDistance)$out, NA, ModeratelyActiveDistance)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {ModeratelyActiveDistance_1 <- ifelse(is.na(ModeratelyActiveDistance_1), mean(ModeratelyActiveDistance, na.rm = TRUE), ModeratelyActiveDistance)})

summary(dailyActivity[c("ModeratelyActiveDistance","ModeratelyActiveDistance_1")])

h <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 1, mapping = aes(ModeratelyActiveDistance)) + theme_bw()
h0 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 1, mapping = aes(ModeratelyActiveDistance_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = ModeratelyActiveDistance)) + theme_bw()
bx0 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = ModeratelyActiveDistance_1)) + theme_bw()

plot_grid(bx,bx0)



###VeryActiveMinutes

summary(dailyActivity$VeryActiveMinutes)
hist(dailyActivity$VeryActiveMinutes)
boxplot.stats(dailyActivity$VeryActiveMinutes)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  VeryActiveMinutes_1 <- ifelse(VeryActiveMinutes %in% boxplot.stats(VeryActiveMinutes)$out, NA, VeryActiveMinutes)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {VeryActiveMinutes_1 <- ifelse(is.na(VeryActiveMinutes_1), mean(VeryActiveMinutes, na.rm = TRUE), VeryActiveMinutes)})

dailyActivity$VeryActiveMinutes_1 <- as.integer(dailyActivity$VeryActiveMinutes_1)

summary(dailyActivity[c("VeryActiveMinutes","VeryActiveMinutes_1")])

h <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 50, mapping = aes(VeryActiveMinutes)) + theme_bw()
h0 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 50, mapping = aes(VeryActiveMinutes_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = VeryActiveMinutes)) + theme_bw()
bx0 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = VeryActiveMinutes_1)) + theme_bw()

plot_grid(bx,bx0)


###FairlyActiveMinutes

summary(dailyActivity$FairlyActiveMinutes)
hist(dailyActivity$FairlyActiveMinutes)
boxplot.stats(dailyActivity$FairlyActiveMinutes)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  FairlyActiveMinutes_1 <- ifelse(FairlyActiveMinutes %in% boxplot.stats(FairlyActiveMinutes)$out, NA, FairlyActiveMinutes)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {FairlyActiveMinutes_1 <- ifelse(is.na(FairlyActiveMinutes_1), mean(FairlyActiveMinutes, na.rm = TRUE), FairlyActiveMinutes)})

dailyActivity$FairlyActiveMinutes_1 <- as.integer(dailyActivity$FairlyActiveMinutes_1)

summary(dailyActivity[c("FairlyActiveMinutes","FairlyActiveMinutes_1")])

h <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 50, mapping = aes(FairlyActiveMinutes)) + theme_bw()
h0 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 50, mapping = aes(FairlyActiveMinutes_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = FairlyActiveMinutes)) + theme_bw()
bx0 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = FairlyActiveMinutes_1)) + theme_bw()

plot_grid(bx,bx0)



###LightlyActiveMinutes

summary(dailyActivity$LightlyActiveMinutes)
hist(dailyActivity$LightlyActiveMinutes)
boxplot.stats(dailyActivity$LightlyActiveMinutes)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  LightlyActiveMinutes_1 <- ifelse(LightlyActiveMinutes %in% boxplot.stats(LightlyActiveMinutes)$out, NA, LightlyActiveMinutes)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {LightlyActiveMinutes_1 <- ifelse(is.na(LightlyActiveMinutes_1), mean(LightlyActiveMinutes, na.rm = TRUE), LightlyActiveMinutes)})

dailyActivity$LightlyActiveMinutes_1 <- as.integer(dailyActivity$LightlyActiveMinutes_1)

summary(dailyActivity[c("LightlyActiveMinutes","LightlyActiveMinutes_1")])

h <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 50, mapping = aes(LightlyActiveMinutes)) + theme_bw()
h0 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 50, mapping = aes(LightlyActiveMinutes_1)) + theme_bw()

plot_grid(h,h0, nrow = 2)

bx <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = LightlyActiveMinutes)) + theme_bw()
bx0 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = LightlyActiveMinutes_1)) + theme_bw()

plot_grid(bx,bx0)


###Calories

summary(dailyActivity$Calories)
hist(dailyActivity$Calories)
boxplot(dailyActivity$Calories)
boxplot.stats(dailyActivity$Calories)$out

### Nullify outliers 
dailyActivity <- within(dailyActivity, {
  Calories_1 <- ifelse(Calories %in% boxplot.stats(Calories)$out, NA, Calories)})

### Impute outliers with mean
dailyActivity <- within(dailyActivity, {Calories_1 <- ifelse(is.na(Calories_1), mean(Calories, na.rm = TRUE), Calories)})

dailyActivity$Calories_1 <- as.integer(dailyActivity$Calories_1)

summary(dailyActivity[c("Calories","Calories_1")])

h1 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 200, mapping = aes(Calories)) + theme_bw()
h2 <- ggplot(dailyActivity) +
  geom_histogram(binwidth = 200, mapping = aes(Calories_1)) + theme_bw()

plot_grid(h1,h2, nrow = 2)

bp1 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = Calories)) + theme_bw()
bp2 <- ggplot(dailyActivity) +
  geom_boxplot(mapping = aes(x = "", y = Calories_1)) + theme_bw()

plot_grid(bp1,bp2)



write_csv(dailyActivity, 'Limpos/clean_outliers_dailyActivity.csv')


###################

#Selecionando e modificando as colunas que serão utilizadas na fase de análise


##dailyActivity

colnames(dailyActivity)

atividade_diaria <- dailyActivity %>%
  select(Id, ActivityDate, TotalSteps_1, TotalDistance, VeryActiveDistance_1, ModeratelyActiveDistance_1,LightActiveDistance,
         VeryActiveMinutes_1, FairlyActiveMinutes_1, LightlyActiveMinutes_1, SedentaryMinutes, Calories_1)

atividade_diaria <- rename(atividade_diaria, data = ActivityDate, total_passos = TotalSteps_1, distancia_total = TotalDistance,
                           distancia_intensa = VeryActiveDistance_1, distancia_moderada = ModeratelyActiveDistance_1,
                           distancia_leve = LightActiveDistance, tempo_intenso_ativo = VeryActiveMinutes_1,
                           tempo_moderado_ativo = FairlyActiveMinutes_1, tempo_leve_ativo = LightlyActiveMinutes_1,
                           tempo_sedentario = SedentaryMinutes, gasto_calorico = Calories_1)

atividade_diaria["distancia_total"] <- atividade_diaria$distancia_intensa + atividade_diaria$distancia_moderada + atividade_diaria$distancia_leve

atividade_diaria["tempo_total"] <- atividade_diaria$tempo_intenso_ativo + atividade_diaria$tempo_moderado_ativo + atividade_diaria$tempo_leve_ativo + atividade_diaria$tempo_sedentario

colnames(atividade_diaria)

atividade_diaria <- select(atividade_diaria,1,2,3,12,7,6,5,4,11,10,9,8,13)

write_csv(dailyActivity, 'Limpos/atividade_diaria.csv')


##sleepDay

colnames(sleepDay)

registro_sono <- sleepDay %>% 
  select(Id, SleepDay, TotalMinutesAsleep_1, TotalTimeInBed_1)

registro_sono <- rename(registro_sono, data = SleepDay, tempo_total_sono = TotalMinutesAsleep_1, tempo_total_na_cama = TotalTimeInBed_1)

registro_sono <- within(registro_sono, {
  tempo_total_sono <- ifelse(tempo_total_sono > tempo_total_na_cama, mean(tempo_total_sono), tempo_total_sono)
})

registro_sono <- within(registro_sono, {
  tempo_total_na_cama <- ifelse(tempo_total_na_cama < tempo_total_sono, mean(tempo_total_na_cama), tempo_total_na_cama)
})

glimpse(registro_sono)

registro_sono$tempo_total_sono <- as.integer(registro_sono$tempo_total_sono)
registro_sono$tempo_total_na_cama <- as.integer(registro_sono$tempo_total_na_cama)

write_csv(dailyActivity, 'Limpos/registro_sono.csv')



#Análise dos dados


##unindo os dataframes pelo ID para sumarizar dados dos mesmos usuários

###como estavam os dfs antes
n_distinct(atividade_diaria$Id)
n_distinct(registro_sono$Id)

nrow(atividade_diaria)
nrow(registro_sono)

###como ficou depois de combiná-los

dfs_combinados <- merge(atividade_diaria, registro_sono, by = c("Id", "data"))

n_distinct(dfs_combinados$Id)
nrow(dfs_combinados)

str(dfs_combinados)
dim(dfs_combinados)
head(dfs_combinados)
tail(dfs_combinados)
glimpse(dfs_combinados)
summary(dfs_combinados)

##explorando variáveis
colnames(dfs_combinados)

###vamos verificar a quantide de passos registrados no período de coletado

ggplot(dfs_combinados) +
  geom_col(mapping = aes(x = data, y = total_passos), fill = "blue") +
  theme_classic()

###vamos verificar o gasto calórico

ggplot(dfs_combinados) +
  geom_col(mapping = aes(x = data, y = gasto_calorico), fill = "red") +
  theme_classic()

###vamos verificar no período que foram coletados os dados, da distância total, qual foi a
###intensidade que compreendeu a maior parte das atividades

install.packages('reshape')
library(reshape)

distancia_categoria <- dfs_combinados

distancia_categoria <- melt(distancia_categoria[c("data","distancia_leve","distancia_moderada","distancia_intensa")], id="data")

dc1 <- ggplot(distancia_categoria) +
  geom_col(mapping = aes(x = data, y = value, fill = variable)) +
  theme_classic()

dc2 <- ggplot(distancia_categoria) +
  geom_col(mapping = aes(x = data, y = value, fill = variable)) + facet_wrap(~variable) +
  theme_classic()

plot_grid(dc1,dc2, nrow = 2)


###vamos verificar no período que foram coletados os dados, da distância total, qual foi a
###intensidade que compreendeu a maior parte das atividades

tempo_categoria <- dfs_combinados

tempo_categoria <- melt(tempo_categoria[c("data","tempo_sedentario","tempo_leve_ativo","tempo_moderado_ativo","tempo_intenso_ativo")], id="data")

tc1 <- ggplot(tempo_categoria) +
  geom_col(mapping = aes(x = data, y = value, fill = variable))

tc2 <- ggplot(tempo_categoria) +
  geom_col(mapping = aes(x = data, y = value, fill = variable)) + facet_wrap(~variable)

plot_grid(tc1,tc2, nrow = 2)


##vamos explorar a correlação dos indicadores

install.packages('corrplot')
install.packages('Hmisc')
library(corrplot)
library(Hmisc)

correlacao_variaveis <- rcorr(as.matrix(dfs_combinados[,3:15]))

corrplot(correlacao_variaveis$r,p.mat=correlacao_variaveis$P,sig.level=0.001,method="color",type="lower")

###verificando algumas correlações mais fortes de forma individualizada

ggplot(dfs_combinados) +
  geom_point(mapping = aes(x = total_passos, y = distancia_total))

ggplot(dfs_combinados) +
  geom_point(mapping = aes(x = tempo_total, y = tempo_sedentario))

ggplot(dfs_combinados) +
  geom_point(mapping = aes(x = tempo_total_na_cama, y = tempo_total_sono))

#destaque para previsão
ggplot(dfs_combinados) +
  geom_point(mapping = aes(x = total_passos, y = distancia_total, color=tempo_total, stroke = 3))




###############################
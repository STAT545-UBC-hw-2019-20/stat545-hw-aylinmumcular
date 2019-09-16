---
title: "Gapminder Exploration"
author: "Aylin Mumcular"
date: "16 09 2019"
output: 
  ioslides_presentation:
    html_document:
    toc: true
    
---


install.packages('rmarkdown')
install.packages('tibble')
install.packages('gapminder')
install.packages('DT')

```{r load, echo = FALSE}

library(tibble)
library(gapminder)
library(DT) 
```


## Data Exploration

```{r cars}
summary(gapminder)
```

## Data Exploration Continued
```{r}
head(gapminder)
```

## Data Exploration Continued

```{r}
tail(gapminder)
```

## Data Exploration Continued

```{r, font_size=10}
nrow(gapminder)
ncol(gapminder)
names(gapminder)[1:3]
names(gapminder)[4:6]
```






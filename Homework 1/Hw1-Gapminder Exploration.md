---
title: "Gapminder Exploration"
author: "Aylin Mumcular"
date: "15 09 2019"
output: 
  pdf_document:
    toc: true
---
## Download Packages

install.packages('rmarkdown')
install.packages('tibble')
install.packages('gapminder')
install.packages('DT')

```{r load, warning = FALSE, echo = FALSE}
library(tibble)
library(gapminder)
library(DT)
```

## Data Exploration

```{r cars}
summary(gapminder)
names(gapminder)
head(gapminder)
nrow(gapminder)
ncol(gapminder)
tail(gapminder)
```



---
title: "HW3-Data Analysis"
author: "Aylin Mumcular"
date: "27 09 2019"
output:
  html_document:
    always_allow_html: yes
    df_print: paged
    pdf_document: default
  pdf_document: default
---
install.packages("gapminder")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggrepel")
install.packages("ggpubr")

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(gapminder)
library(tidyverse)
library(dplyr)
library(ggrepel)
library(ggpubr)
```


Produce:

- A tibble, using dplyr as your data manipulation tool
- An accompanying plot of data from the tibble, using ggplot2 as your visualization tool
- Some dialogue about what your tables/figures show (doesn’t have to be much)

1. Get the maximum and minimum of GDP per capita for all continents.

```{r}

#Tibble
gapminder %>% 
  group_by(continent) %>% 
  summarize(maxGDPpercap = max(gdpPercap),
            minGDPpercap = min(gdpPercap)) %>% 
              arrange(maxGDPpercap)

#Plot
p1 <- gapminder %>% 
  group_by(continent) %>% 
  summarize(maxGDPpercap = max(gdpPercap),
            minGDPpercap = min(gdpPercap)) %>% 
             ggplot(aes(continent, minGDPpercap)) +
               geom_point(colour = "red") +
                  geom_label_repel(aes(label = minGDPpercap),
  #To add values as labels 
  #(source: https://stackoverflow.com/questions/15624656/label-points-in-geom-point)
                  box.padding   = 0.35, 
                  point.padding = 0.5,
                  segment.color = 'grey50') +
                  ylab("min GDP per cap")

p2 <- gapminder %>% 
  group_by(continent) %>% 
  summarize(maxGDPpercap = max(gdpPercap),
            minGDPpercap = min(gdpPercap)) %>% 
             ggplot(aes(continent, maxGDPpercap)) +
               geom_point(colour = "blue") +
                  geom_label_repel(aes(label = maxGDPpercap), 
                  box.padding   = 0.35, 
                  point.padding = 0.5,
                  segment.color = 'grey50') +
                  ylab("max GDP per cap")

ggarrange(p1, p2, nrow = 2, ncol = 1) #Combine two plots
```

Minimum GDP per capita order of continents from highest to lowest is Oceania, Americas, Europe, Asia, and Africa whereas maximum GDP per capita order of continents from highest to lowest is Asia, Europe, Americas, Oceania, and Africa. Africa is the lowest GDP per capita continent according to both maximum and minimum GDP per capita measures. Asia has the highest gap between countries in terms of GDP per Capita. 

2. Look at the spread of GDP per capita within the continents.

```{r, fig.height=8}

#Tibble
gapminder %>% 
  group_by(continent) %>% 
  summarize(maxGDPpercap = max(gdpPercap),
            minGDPpercap = min(gdpPercap),
            rangeGDPpercar = max(gdpPercap)-min(gdpPercap),
            stdGDPpercap = sd(gdpPercap),
            meanGDPpercap = mean(gdpPercap),
            medianGDPpercap = median(gdpPercap),
            firstquantile = quantile(gdpPercap, 0.25),
            thirdquantile = quantile(gdpPercap, 0.75))
             
#Plot
gapminder %>% 
  ggplot(aes(continent, gdpPercap, fill = continent)) + 
  geom_boxplot()

```

Asia has the highest range and standard deviation in terms of GDP per capita while Africa has the lowest. Europe has the highest interquantile range. Oceania has the highest mean and median GDP per capita, followed by Europe.  

3. How is life expectancy changing over time on different continents?

```{r, fig.width=20, fig.height=10}

#Tibble
gapminder %>% 
  group_by(continent, year) %>% 
    summarize(maxlifeExp = max(lifeExp),
            minlifeExp = min(lifeExp),
            meanlifeExp = mean(lifeExp),
            medianlifeExp = median(lifeExp))

#Plot
gapminder %>% 
  mutate(year = factor(year)) %>% 
  #Convert year from numeric to factor to print multiple boxplots within each year
    ggplot(aes(year, lifeExp, fill = continent)) + 
    geom_boxplot() +
    ylab("life expectancy")

#Plot 2
gapminder %>%
  group_by(continent, year) %>% 
    summarize(meanlifeExp = mean(lifeExp)) %>% 
      ggplot(aes(year, meanlifeExp, group = continent, colour = continent)) +
      geom_line() + 
      ylab("mean life expectancy")



```

In general, there is an increasing trend in the life expectancy of each continent over time. Oceania and Africa have experienced some drop in life expectancy in the past. 
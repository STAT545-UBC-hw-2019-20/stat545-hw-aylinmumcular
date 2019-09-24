---
title: "HW2-Data Analysis"
author: "Aylin Mumcular"
date: "21 09 2019"
output:
  pdf_document: default
  html_document:
    df_print: paged
always_allow_html: yes
---
install.packages("gapminder")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("entropy")

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(gapminder)
library(tidyverse)
library(dplyr)
library(entropy)
```

1.1 Use filter() to subset the gapminder data to three countries of your choice in the 1970’s.

```{r}
rm(list = ls(all.names = TRUE)) #Clear the environment

knitr::kable((gap70 <-  gapminder %>% 
                filter(country == "Afghanistan" | country == "Albania" | country == "Algeria",      
                   year >= 1970 & year < 1980)))

```

1.2 Use the pipe operator %>% to select “country” and “gdpPercap” from your filtered dataset in 1.1.

```{r}
knitr::kable(gap70 %>% 
          select(country, gdpPercap))
```

1.3 Filter gapminder to all entries that have experienced a drop in life expectancy. Be sure to include a new variable that’s the increase in life expectancy in your tibble. Hint: you might find the lag() or diff() functions useful.


```{r}

lifeExpDiff <- 0 #Define an empty array
length <- nrow(gapminder)-1 #For loop upper end

#Assign the first element to zero since one cannot make any comparison 
#with the first data point
lifeExpDiff[1] <- 0  

for (k in 1:length) {lifeExpDiff[k+1] <- 
      if (
           select(gapminder[k+1,], country) == select(gapminder[k,], country)) { 
        #If countries are the same for subsequent rows
        
           select(gapminder[k+1,], lifeExp) - select(gapminder[k,], lifeExp)} 
        #Calculate the difference
      else {0}  
        #Else, assign the first element of each country to zero
                    }

#Unlist the lifeExpDiff2 array to attach the gapminder dataset with mutate
lifeExpDiff2 <- unlist(lifeExpDiff, use.names=FALSE) 

gapminder2 <- mutate(gapminder, lifeExpDiff2) #Combined dataset

DT::datatable(gapminder2 %>% filter(lifeExpDiff2<0)) #Filter the results


```


1.4 Filter gapminder to contain six rows: the rows with the three largest GDP per capita, and the rows with the three smallest GDP per capita. Be sure to not create any intermediate objects when doing this (with, for example, the assignment operator). Hint: you might find the sort() function useful, or perhaps even the dplyr::slice() function.

```{r}
#Sort the dataset according to descending gdpPercap 
#Concatenate the first and last three data points

knitr::kable(rbind(slice(arrange(gapminder, desc(gdpPercap)), 1:3), 

slice(arrange(gapminder, desc(gdpPercap)), (nrow(gapminder)-2):nrow(gapminder)))) 
```

1.5 Produce a scatterplot of Canada’s life expectancy vs. GDP per capita using ggplot2, without defining a new variable. That is, after filtering the gapminder data set, pipe it directly into the ggplot() function. Ensure GDP per capita is on a log scale.

```{r}

gapminder %>% 
  filter(country == "Canada") %>% 
  mutate(loggdp = log10(gdpPercap)) %>% #Log scale gdpPercap
  ggplot(aes(lifeExp, loggdp)) +
  geom_point() +
  theme_bw() + 
  xlab("Canada’s life expectancy") + 
  ylab("GDP per capita")

```


2 Pick one categorical variable and one quantitative variable to explore. Answer the following questions in whichever way you think is appropriate: What are possible values (or range, whichever is appropriate) of each variable? What values are typical? What’s the spread? What’s the distribution? Etc., tailored to the variable at hand.
Feel free to use summary stats, tables, figures.




Categorical: country
```{r}

levels(gapminder$country) #Possible values for countries
nlevels(gapminder$country) #Total number of possible countries
head(table(gapminder$country)) #How many time a country appears in the data
entropy(table(gapminder$country)) #Calculate entropy as another measure of the “spread” of values
#Plot the spread/distribution of the number of times a country appears
plot(table(gapminder$country)) 

```

There are 142 different countries that are expressed with the levels function. Each country appears 12 times uniformly.




Quantitative: lifeExp
```{r}


summary(gapminder$lifeExp) #Summary statistics
sd(gapminder$lifeExp)
boxplot(gapminder$lifeExp) #Visual illustration of the summary statistics
entropy(gapminder$lifeExp) #Calculate entropy
#Plot the histogram to see which values are typical and understand the spread/distribution
gapminder %>% 
  ggplot(aes(lifeExp)) +
  geom_histogram(bins=15) + 
  theme_bw() +
  xlab("Life Expectancy") 
  
```

lifeExp variable is between 23.60 and 82.60 with a mean of 59.47 for all data points. According to the histogram of lifeExp variable which shows its distribution, it is more likely that this variable is between 70 and 75. 





3 Make two plots that have some value to them. That is, plots that someone might actually consider making for an analysis: A scatterplot of two quantitative variables, one other plot besides a scatterplot.

```{r}
data <- datasets::iris

# Scatter plot
ggplot(data) +
  geom_abline(intercept = 0, slope = 0.8) +
  geom_point(aes(x = Sepal.Length, y = Petal.Length), alpha = 0.2, color = "blue") +
  theme_bw() +
  xlab("Sepal Length") +
  ylab("Petal Length") 

# The other plot

data %>% 
  ggplot(aes(Species, Sepal.Length)) +
  geom_violin(draw_quantiles = c(.25, .5, .75), trim=FALSE) +
  theme_bw() +
  xlab("Species") +
  ylab("Sepal Length") 

  
```


Optional Question

The code results in half of the data available for both Afghanistan and Rwanda. Out of 12 data points for each contry, only 6 of them were captured with this filtering. Hence, they did not succeed in getting all the data for Rwanda and Afghanistan. The code can be fixed with two different ways.


```{r}


knitr::kable(filter(gapminder, country == c("Rwanda", "Afghanistan")))


#First correction
DT::datatable(filter(gapminder, country %in% c("Rwanda", "Afghanistan"))) 

#or

#Second correction
DT::datatable(filter(gapminder, country == "Rwanda" | country == "Afghanistan")) 



```




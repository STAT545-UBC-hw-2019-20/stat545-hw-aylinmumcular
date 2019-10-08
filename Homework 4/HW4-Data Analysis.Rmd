---
title: "HW4-Data Analysis"
author: "Aylin Mumcular"
date: "05 10 2019"
output:
  pdf_document: default
  html_document:
    always_allow_html: yes
    df_print: paged
    pdf_document: default
---
install.packages("tidyverse")
install.packages("dplyr")
install.packages("gapminder")

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(dplyr)
library(gapminder)
```

Q1 Univariate Option 1

1. Make a tibble with one row per year, and columns for life expectancy for two or more countries.

```{r}
(gap_wider <- gapminder %>% 
               filter(country == "Canada" | country == "Turkey") %>% 
                  pivot_wider(id_cols = year, 
                          names_from = country, 
                          values_from = lifeExp))
                
```


2. Take advantage of this new data shape to scatterplot life expectancy for one country against that of another.

```{r}

gap_wider %>% 
  ggplot(aes(Turkey, Canada)) +
  geom_point(colour = "blue")

```


3. Re-lengthen the data.

```{r}

(gap_longer <- gap_wider %>% 
                  pivot_longer(cols = c("Canada", "Turkey"), 
                          names_to = "country", 
                          values_to = "lifeExp"))

```

Q2 Multivariate Option 1

1. Make a tibble with one row per year, and columns for life expectancy and GDP per capita (or two other numeric variables) for two or more countries.

```{r}

(gap_wider_mult <- gapminder %>% 
                    filter(country == "Canada" | country == "Turkey") %>% 
                      pivot_wider(id_cols     = year, 
                                  names_from  = country, 
                                  names_sep   = "_", 
                                  values_from = c(lifeExp, gdpPercap)))

```


2. Re-lengthen the data.

```{r}

(gap_longer_mult <- gap_wider_mult %>% 
                      pivot_longer(cols = c(-year), 
                          names_to = c(".value", "country"),
                          names_sep = "_"))

```

Q3 Table Joins

```{r}

guest <- read_csv("https://raw.githubusercontent.com/STAT545-UBC/Classroom/master/data/wedding/attend.csv")
email <- read_csv("https://raw.githubusercontent.com/STAT545-UBC/Classroom/master/data/wedding/emails.csv")


```

3.1 For each guest in the guestlist (guest tibble), add a column for email address, which can be found in the email tibble.

```{r}

e_sep <- as_tibble(email) %>% 
          rename(name = guest) %>% #Change the name so that it will match in both tables
            separate_rows(name, sep = ", ") #Separate names

    
guest %>% 
  left_join(e_sep, by = "name")

```

3.2 Who do we have emails for, yet are not on the guestlist?

```{r}

e_sep %>% 
  anti_join(guest, by = "name")

```

3.3 Make a guestlist that includes everyone we have emails for (in addition to those on the original guestlist).

```{r}

guest %>% 
  full_join(e_sep, by = "name")

```




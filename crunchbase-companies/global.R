##shiny packages
library(shiny)
library(shinydashboard)
library(htmlwidgets)
library(sparkline)
library(DT)
library(xtable)

##sql and ts packages
library(RSQLite)
library(DBI)
library(zoo)
library(xts)

##data cleaning and functional packages
library(dplyr)
library(tidyr)
library(purrr)
library(magrittr)
library(lazyeval)



con = dbConnect(RSQLite::SQLite(), dbname='../data/companies.sqlite')
q1 <- "SELECT distinct(investor_name) FROM investments"

q5 = "SELECT investments.investor_name, count(investments.company_name) as total_funded, sum(investments.raised_amount_usd) as total_investments, sum(CASE rounds.status WHEN 'acquired' THEN 1 ELSE 0 END) as exits
FROM investments
JOIN rounds ON investments.company_name = rounds.name
WHERE NULLIF(investments.investor_name, '') IS NOT NULL
GROUP BY investments.investor_name
HAVING total_funded > 20
ORDER BY investor_name";

q.investors <- dbGetQuery(con, q5)
investor_names <- gsub("[^0-9A-Za-z///' ]", "", q.investors$investor_name)


##


function(input, output, session) {
  ## data prep
  
  
  get.investor <- function(){
    investor <- input$investors
    investor <- as.character(investor)
    investor
  }
  
  summary.data <- function(){
    investor <- get.investor()
    data <- q.investors%>%
      filter(., investor_name == investor)
    data

  }
  
  #c <- input$company
  
  run.sql.query <- function(){
    c <- get.investor()
    q2 = sprintf("SELECT company_name, funded_at, investor_name, funding_round_code
  FROM investments
  WHERE company_name IN (
  SELECT company_name
  FROM investments
  WHERE investor_name == '%s')", c)
    
    t1 <- dbGetQuery(con, q2)
    ## convert date field from character to timeseries
    t1$funded_at <- as.Date(t1$funded_at, format="%m/%d/%Y")
    
    ##remove escape strings from name field
    t1$investor_name <- gsub("[^0-9A-Za-z///' ]", "", t1$investor_name)
    t1$funding_round_code <- gsub("[^0-9A-Za-z///' ]", "", t1$funding_round_code)
    t1
  }

  
  funded.with <- function(){
    c <- get.investor()
    t1 <- run.sql.query()
    investor.funded <- select(t1, investor_name, company_name, funded_at)%>%
      filter(investor_name==c)%>%
      mutate(investor_funded=funded_at)%>%
      select(company_name, investor_funded)
    
    count.with.investor <- t1%>%
      base::merge(., investor.funded, by="company_name", all = TRUE)%>%
      mutate(funded_before=ifelse((funded_at < investor_funded), investor_name, 0))%>%
      mutate(funded_after=ifelse((funded_at > investor_funded), investor_name, 0))%>%
      mutate(funded_same=ifelse((funded_at == investor_funded), investor_name, 0))%>%
      filter(funded_same != c)%>%
      filter(funded_before != c)%>%
      filter(funded_before != c)
    
    count.with.investor
    
  }

  data.before <- function(){
    count.with.investor <- funded.with()
    count.before <- select(count.with.investor, funded_before, funded_at, funding_round_code)%>%
      filter(funded_before != 0) %>%
      mutate(year=format(funded_at, "%Y"))%>%
      select(funded_before, year, funding_round_code)%>%
      group_by(funded_before, year, funding_round_code)%>%
      mutate(count=n())%>%
      unique(.)
    
    total.before <- select(count.with.investor, funded_before)%>%
      group_by(funded_before)%>%
      summarise(count=n())%>%
      filter(count>=10)%>%
      filter(funded_before != 0)%>%
      base::merge(., count.before, by="funded_before", all.x= TRUE)
    total.before
  }
  
  data.after <- function(){
    count.with.investor <- funded.with()
    count.after <- select(count.with.investor, funded_after, funded_at, funding_round_code)%>%
      filter(funded_after != 0) %>%
      mutate(year=format(funded_at, "%Y"))%>%
      select(funded_after, year, funding_round_code)%>%
      group_by(funded_after, year, funding_round_code)%>%
      mutate(count=n())%>%
      unique(.)
    
    total.after <- select(count.with.investor, funded_after)%>%
      group_by(funded_after)%>%
      summarise(count=n())%>%
      filter(count>=10)%>%
      filter(funded_after != 0)%>%
      base::merge(., count.after, by="funded_after", all.x= TRUE)
    total.after
  }

  data.with <- function(){
    count.with.investor <- funded.with()
    count.with <- select(count.with.investor, funded_same, funded_at, funding_round_code)%>%
      filter(funded_same != 0) %>%
      mutate(year=format(funded_at, "%Y"))%>%
      select(funded_same, year, funding_round_code)%>%
      group_by(funded_same, year, funding_round_code)%>%
      mutate(count=n())%>%
      unique(.)
    
    total.with <- select(count.with.investor, funded_same)%>%
      group_by(funded_same)%>%
      summarise(count=n())%>%
      filter(count>=10)%>%
      filter(funded_same != 0)%>%
      base::merge(., count.with, by="funded_same", all.x= TRUE)
    total.with
  }

  ### data to list here
  
  data.to.list <- function(dataframe, var){
    data <- dataframe
    list.fund <-  data %>%
      group_by_(var, "funding_round_code")%>%
      summarize(count.f = n())%>%
      filter(funding_round_code != "")%>%
      summarise(
        count_round = paste(count.f, collapse = ",")
      )
    
    list.year <- data %>%
      group_by_(var)%>%
      summarize(
        count.t = paste(count.y, collapse = ",")
      )%>%
      base::merge(., list.fund, by=var, all=TRUE)
    
    
    names <- c("Investor", "Year", "Series")
    names(list.year) <- names
    list.year
  }
    
  ## functions to interact with css and javascript classes
  columnDefs = list(list(
    targets = 2,
    render = JS("function(data, type, full){
                return '<span class=sparkYear>' + data + '</span>'           
}")), 
  list(
    targets = 3,
    render = JS("function(data, type, full){
                return '<span class=sparkSeries>' + data + '</span>'           
                }")))

  
  fnDrawCallback = JS("function (oSettings, json) {
                      $('.sparkYear:not(:has(canvas))').sparkline('html', { type: 'line', highlightColor: 'orange' });
                      $('.sparkSeries:not(:has(canvas))').sparkline('html', { type: 'bar', highlightColor: 'orange' });
                      }")

  
  
  
  ## end of data prep and start of charts
  output$investments <- renderValueBox({

    
    valueBox(
      value = summary.data()$total_investments,
      subtitle = "$ Invested",
      icon = icon("usd"),
      color = 'purple'
    )
  })
  
  output$funded <- renderValueBox({
    valueBox(
      value = summary.data()$total_funded,
      subtitle = "# Companies",
      icon = icon("pie-chart"),
      color='purple'
    )
  })
  
  output$exits <- renderValueBox({
    valueBox(
      value = summary.data()$exits,
      subtitle = "# Exits",
      icon = icon("stats", lib = "glyphicon"),
      color = 'purple'
    )
  })
  
  
  output$x1 <- DT::renderDataTable({
    
    before.list <- data.to.list(data.before(), "funded_before")
    d1 <- datatable(before.list, options = list(
      columnDefs = columnDefs,
      fnDrawCallback = fnDrawCallback
    ))
    d1$dependencies <- append(d1$dependencies, htmlwidgets:::getDependency("sparkline"))
    d1
    
  })
  
  output$x2 <- DT::renderDataTable({

    after.list <- data.to.list(data.after(), "funded_after")
    d1 <- datatable(after.list, options = list(
      columnDefs = columnDefs,
      fnDrawCallback = fnDrawCallback
    ))
    d1$dependencies <- append(d1$dependencies, htmlwidgets:::getDependency("sparkline"))
    d1
  })
  
  output$x3 <- DT::renderDataTable({
    
    list.with <- data.to.list(data.with(), "funded_same")
    
    d1 <- datatable(list.with, options = list(
      columnDefs = columnDefs,
      fnDrawCallback = fnDrawCallback
    ))
    d1$dependencies <- append(d1$dependencies, htmlwidgets:::getDependency("sparkline"))
    d1
    
  })
  

  

  
  ##end of doc
}

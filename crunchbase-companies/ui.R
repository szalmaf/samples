dashboardPage(skin="purple",
dashboardHeader(title = "Visualizing Follow-Ons with Crunchbase Data",
                titleWidth = 450),
  dashboardSidebar(disable = TRUE
  ),
dashboardBody(
    #tabItems(
     # tabItem("dashboard",
              fluidRow(
                valueBoxOutput("investments"),
                valueBoxOutput("funded"),
                valueBoxOutput("exits")
              ),
              fluidRow(
                box(
                  width = 12, status = "info",
                  selectInput(inputId = "investors",
                              label = "Select Investor",
                              choices = c(sort(unique(as.character(investor_names)))),
                              selected = "Greylock Partners")

                ),

                box(
                  width = 4, status = "info",
                  title = "Companies Invested Before",
                  DT::dataTableOutput("x1")
                ),
                box(
                  width = 4, status = "info",
                  title = "Companies Invested After",
                  DT::dataTableOutput("x2")
                ),
                box(
                  width = 4, status = "info",
                  title = "Companies Invested With",
                  DT::dataTableOutput("x3")
                )
                
                
              )
           ) #end of tabItem

## end of document
    )
#  )
#)

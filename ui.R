shinyUI(
        pageWithSidebar(
                # Application title
                headerPanel("Incidence Rate Calculator"),
                sidebarPanel(
                        h4('To determine the estimated incidence rate of a disease for a specific population. Please select a disease from the list and enter 
                            the number of people at risk at the beginning of the time interval along the number of people at risk at the end of the time interval,
                            and the measure of time.'),
                        selectInput("disease", "Choose disease:", choices=c('malaria'=1, 'flu'=2, 'ebola'=3, 'measles'=4)),
                        numericInput('BegAtRisk', 'Number of people at risk at beginning of time period:', 100, min = 10),
                        numericInput('EndAtRisk', 'Number of people at risk at end of time period \n
                                     (# above - # developed disease):', 0, min = 0),
                        numericInput('timeunits', 'Number of time periods', 0, min = 50, max = 200, step = 5),
                        selectInput("timetype", "Choose time period:", choices=c('days'=1, 'months'=2, 'years'=3)),
                        actionButton("submitButton", "Submit")
                ),
                mainPanel(
                        h4('New Cases'),
                        verbatimTextOutput("newcases"),
                        h4('Person Time at Risk '),
                        verbatimTextOutput("timeatrisk"),
                        h4('Time Interval '),
                        verbatimTextOutput("timeinterval"),
                        h4('Incidence Rate '),
                        verbatimTextOutput("rate"),
                        plotOutput("newpie")
                        
                )
        )
)
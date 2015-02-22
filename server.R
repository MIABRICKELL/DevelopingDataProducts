library(shiny)

#calculate the number of new cases
newcases <- function(start, end) {start - end}

#calculate the Person-Time at risk estimate
risktime <- function(begrisk, endrisk, timeunits)
{
        (begrisk+endrisk/2) * timeunits
}

#function to convert to format a decimal to a percentage
percent <- function(x, digits = 2, format = "f", ...) {
        paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

shinyServer(
        function(input, output) {
                #return the name of the disease
                getdisease <-reactive(
                        {if(input$disease=='1') "malaria"
                         else if (input$disease=='2') "flu"
                         else if (input$disease=='3') "ebola"
                         else if (input$disease=='4') "measles"})
                
                #retun the name of the time type with correct format
                gettype <-reactive(
                        {if(input$timetype=='1') "day"
                         else if (input$timetype=='2') "month"
                         else if (input$timetype=='3') "year"})
                         
                
                gettypef <-reactive(
                        {if(input$timetype=='1' && input$timeunits==1) "day"
                         else if(input$timetype=='1' && input$timeunits>1) "days"
                         else if (input$timetype=='2' && input$timeunits==1) "month"
                         else if (input$timetype=='2' && input$timeunits>1) "months"
                         else if (input$timetype=='3' && input$timeunits==1) "year"
                         else if (input$timetype=='3' && input$timeunits>1) "years"})
                
                #retun # of time units if greater than zeo
                gettimeunits <-reactive(
                        {if(input$timeunits>0) input$timeunits else ""})
                
                #reactive function to calculate the new cases
                ncases <- reactive({newcases(input$BegAtRisk, input$EndAtRisk)})
                
                #reactive function to calculate the person-time at risk
                rtime <- reactive({risktime(input$BegAtRisk, input$EndAtRisk, input$timeunits)})
                
                output$newcases <- renderPrint({
                        if(input$submitButton == 0) ""
                           else
                           {
                               input$submitButton
                               isolate(ncases())
                           }})
        
                output$timeatrisk <- renderPrint({
                        if(input$submitButton == 0) ""
                           else
                           {
                                input$submitButton
                                isolate(rtime())
                           }})
                output$timeinterval <-renderPrint({
                        if(input$submitButton == 0) ""
                        else 
                        {
                                input$submitButton
                                isolate(paste0(gettimeunits(), " ", gettypef()))
                        }})
                output$rate <- renderPrint({
                        if(input$submitButton == 0) "Need to hit submit button."
                        else
                        {
                                input$submitButton
                                isolate({if(rtime()>0) paste0(percent(ncases()/rtime()), " of the people are getting ", getdisease(), " each ", gettype(), ".")
                                else paste0("None of the people are getting ", getdisease(), " or time needs to be more than 0.")})
                        }})
                output$newpie <- renderPlot({
                        if(input$submitButton == 0) ""
                        else
                        {
                                input$submitButton
                                isolate({mypie <- c(input$EndAtRisk, ncases())              
                                names(mypie)<-c('Still at Risk', 'Developed Disease')
                                pie(mypie, col = c("green", "red"))})
                        }
                })
        }
)
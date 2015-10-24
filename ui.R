shinyUI(fluidPage(
  titlePanel(em(h1("Where in Ireland do I fit in?"))),
  br(),
  br(),
  
  sidebarLayout(
    sidebarPanel( 
      
      h4("Select highest educational level"),
      selectInput("Edu",
                  label="Select",choices=list("Doctorate (Ph.D)","Full-time education has not ceased","Higher certificate","Honours bachelor degree","Lower secondary","No formal education","Not stated","Ordinary bachelor degree","Postgraduate diploma or degree","Primary","Technical/vocational","Upper secondary")),
      
                  h4("Select birth country"),
                  selectInput("Country",
                              label="Select", choices= list("Ireland", "Austria" ,"Australia" ,"Bangladesh" ,"Belgium" ,"Bulgaria" ,"Brazil" ,"Canada" ,"Congo" ,"China" ,"Cyprus" ,"Czech Republic" ,"Germany" ,"Denmark" ,"Estonia" ,"Spain" ,"Finland" ,"France" ,"Greece" ,"Hong Kong" ,"Hungary" ,"India" ,"Italy" ,"Lithuania" ,"Luxembourg" ,"Latvia" ,"Moldova, Republic of" ,"Malta" ,"Mauritius" ,"Malaysia" ,"Nigeria" ,"Netherlands" ,"New Zealand" ,"Philippines" ,"Pakistan" ,"Poland" ,"Portugal" ,"Romania" ,"Russian Federation" ,"Sweden" ,"Slovenia" ,"Slovakia" ,"Ukraine" ,"United States" ,"England and Wales" ,"Northern Ireland" ,"Scotland" ,"South Africa" ,"Zimbabwe" ,"Other Africa (4)" ,"Other Asian countries (2)" ,"Other Oceanic countries (1)" ,"Other America (4)")),
                  h4("Select gender"),
                  selectInput("Sex",
                              label="Select",choices=list("Male", "Female")),
                  h4("Select marital status"),
                  selectInput("Marital",
                              label="Select",choices=list("Single","Married","Separated","Divorced","Widowed")),
                  h4("Select age range"),
                  selectInput("AgeRange",
                              label="Select",choices=list("0 - 4 years","5 - 9 years","10 - 14 years","15 - 19 years","20 - 24 years","25 - 29 years","30 - 34 years","35 - 39 years","40 - 44 years","45 - 49 years","50 - 54 years","55 - 59 years","60 - 64 years","65 - 69 years","70 - 74 years","75 - 79 years","80 - 84 years","85 years and over")),
                  img(src="census2011_logo.jpg", height = 200, width = 200)),
    
    mainPanel(
      tabsetPanel(
        tabPanel('Documentation',
        h1("Demographics of Ireland by county"),
        
        h2("Summary"),
        
        p("This application ranks counties and cities in Ireland based on the demographic categories selected by the user. The source of the data is the 2011 Irish census."),
        
        h2("Source of data"),
        
        p("The data is read interactively from the Irish", a("Central Statistics Office website", href = "http://www.cso.ie/en/census/index.html")),
        p("The files provide geographical breakouts of the census by: "),
        tags$ul(
        tags$li("Highest educational level achieved"),
        tags$li("Country of origin"),
        tags$li("Gender"),
        tags$li("Marital Status"),
        tags$li("Age Range")
),

h2("Instructions"),
p("Select an option for each of the demographic categories from the side panel"),
p("The tabs will then rank the counties of Ireland by population percentage of each county aligned with the demographic categories chosen."),
p("Enjoy!")),
        tabPanel('Education',
                 dataTableOutput("edutable")),
        tabPanel('Nationality',
                 dataTableOutput("origtable")),
        tabPanel('Sex',
                 dataTableOutput("sextable")),
        tabPanel('Marital Status',
                 dataTableOutput("martable")),      
        tabPanel('Age Group',
                 dataTableOutput("agetable"))
      )
    )
  )
))
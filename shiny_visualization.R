#load libraries
library(shiny)
library(tidyverse) 
library(ggplot2)
library(bslib)
library(DT)
library(thematic)

#read in the data
percentiles = read.csv("https://github.com/jquam15/nba_draft_visualization/raw/main/visualization_data.csv") %>%
  #The percentiles were calculated with everyone in mind, but I'm only interested in visualizing this years draft class so I'm filtering
  filter(Draft.Year == 2022) %>%
  #rename the columns
  rename("Draft Year" = "Draft.Year", "Draft Age" = "Draft.Age", "Standing Reach" = "Standing.Reach", "RSCI Ranking" = "RSCI.Ranking",
         "TS%" = "TS.", "eFG%" = "eFG.", "ORB%" = "ORB.", "DRB%" = "DRB.", "TRB%" = "TRB.", "AST%" = "AST.", "STL%" = "STL.", 
         "BLK%" = "BLK.", "TOV%" = "TOV.", "USG%" = "USG.", "College OBPM" = "College.OBPM", "College DBPM" = "College.DBPM",
         "College BPM" = "College.BPM")


historical = read.csv("https://github.com/jquam15/nba_draft_visualization/raw/main/visualization_data.csv") %>%
  #filter out the current prospects for historical dataset
  filter(Draft.Year != 2022) %>%
  #rename the columns
  rename("Draft Year" = "Draft.Year", "Draft Age" = "Draft.Age", "Standing Reach" = "Standing.Reach", "RSCI Ranking" = "RSCI.Ranking",
         "TS%" = "TS.", "eFG%" = "eFG.", "ORB%" = "ORB.", "DRB%" = "DRB.", "TRB%" = "TRB.", "AST%" = "AST.", "STL%" = "STL.", 
         "BLK%" = "BLK.", "TOV%" = "TOV.", "USG%" = "USG.", "College OBPM" = "College.OBPM", "College DBPM" = "College.DBPM",
         "College BPM" = "College.BPM")


#get list of players who withdrew from the draft
withdrawal_players = c("Drew Timme", "Matthew Mayer", "Jalen Wilson", "Julian Strawther", "Terquavion Smith", "Harrison Ingram")

#read in the player stats
player_stats = read.csv("https://github.com/jquam15/nba_draft_visualization/raw/main/prospect_stats_2022.csv") %>%
  #filter out the players that withdrew from the draft
  filter(!Player %in% withdrawal_players) %>%
  #rename the columns
  rename("Draft Year" = "Draft.Year", "Draft Age" = "Draft.Age", "Standing Reach" = "Standing.Reach", "RSCI Ranking" = "RSCI.Ranking",
         "TS%" = "TS.", "eFG%" = "eFG.", "ORB%" = "ORB.", "DRB%" = "DRB.", "TRB%" = "TRB.", "AST%" = "AST.", "STL%" = "STL.", 
         "BLK%" = "BLK.", "TOV%" = "TOV.", "USG%" = "USG.", "College OBPM" = "College.OBPM", "College DBPM" = "College.DBPM",
         "College BPM" = "College.BPM")

#define hex codes for background, text that I used to make the plot
color_hexes = c("#101010", "#FDF7F7")

#define function used in shiny plots
percentile_plot = function(df, player, cols) {
  print(df)
  #this is the code to make the visualization function
  ggplot(df, aes(x=Percentiles, y=Column, col=Percentiles)) +
    #plot the point
    geom_point(aes(size=2)) +
    #don't want a y lable
    labs(x="Percentile Rank", y="", title = paste0("Percentile Ranks for ", player)) +
    #want the x axis scale to be from 0 to 1 (whole percentile scale)
    xlim(c(0,1)) +
    #want a color gradient with blue indicating a weakness to red indicating a strength
    scale_color_gradient(low = "lightblue", high = "red") +
    #don't need to include size in the legend as points are all the same size (just wanted them bigger)
    guides(size="none") +
    #set a black and white them
    theme(
      panel.border = element_rect(color = cols[2], fill=NA),
      plot.background = element_rect(fill = cols[1]),
      panel.background = element_rect(fill = cols[1]),
      panel.grid.major = element_line(color = cols[2]),
      panel.grid.minor = element_line(color = cols[2]),
      title = element_text(color = cols[2], size=24),
      axis.title.x = element_text(color = cols[2]),
      axis.text.x = element_text(color = cols[2]),
      axis.text.y = element_text(color = cols[2]),
      axis.text = element_text(size = 16),
      legend.text = element_text(color = cols[2], size=12),
      legend.title = element_text(color = cols[2]),
      legend.background = element_rect(fill = cols[1])
    )
}

#define the function used to get similar players in the shiny app
get_similar_players = function(val, col, pos, df=historical) {
  #this pipeline finds 5 the most similar historical comparisons for the selected data point
  df %>% 
    #filter to only the position of the selected player (percentiles were calculated by position)
    filter(Position == pos) %>%
    #create a distance column by taking the absolute value between the player's value (x-axis click input) and the historical values
    mutate(Dist = abs(val - .data[[col]])) %>%
    #arrange to get the 5 closest values
    arrange(Dist) %>%
    #select the appropriate columns
    select(Player, Position, `Draft Year`, School) %>%
    #take the 3 closest values
    head(3)
}

#text to help viewer understand the plots
descriptive_text = "This visual allows you to select a 2022 NBA draft prospect and view what percentile rank they are in each category relative to my historical NBA draft prospect dataset going back to the 2010-11 season (the first year BPM was calculated for college basketball). Percentiles were computed with respect to basketball position to account for differences between certain positions (Ex: Centers are taller than Point Guards), and high percentile ranks represent a strenght in all cases. If the 'desirable' trait corresponds to a low numerical value (Ex: all else equal, younger prospects are more desirable) I took 1 minus the percentile rank to indicate the more 'desirable' trait to be a strength. Another function of this plot is that you can click a point to see a data table with the 3 most similar players to the selected prospect for the given category in the historical dataset. For example, if I clicked the point corresponding to AJ Griffin's Wingspan percentile, I would see that his wingspan was most similar to Dorian Finney-Smith. If no point is selected, player information for all 2022 draft prospects is displayed. To return to viewing the full table after clicking a point, refresh the page. Overall, this application provides a general sense of 2022 NBA draft prospects' strengths and weaknesses as well as historical comparisons for specific features."  
#link to my github repo
github_link = "<br>If you would like more context regarding the data please check out the README file on my <a href='https://github.com/jquam15/nba_draft_visualization'> github</a>"
#link to my website
web_link = "If you'd like to see more cool content check out my <a href='https://jquam15.github.io/'>website</a>"


#get a list of unique player names
players = sort(unique(percentiles$Player))

#ui component of shiny app
#get a list of unique player names
players = sort(unique(percentiles$Player))

#ui component of the Shiny app
ui <- fluidPage(
  #customize theme using bslib bs_theme() function
  theme = bs_theme(
    bootswatch = "darkly",
    base_font = font_google("PT Serif")
  ),
  #carry the theme (font style) throughout the table and plots
  thematic_shiny(font="auto"),
  #add title
  column(8, align="center", offset=2, titlePanel("2022 NBA Draft Prospect Visualization")),
  #set up the descriptive text and web link elements
  column(12, align="center", htmlOutput("descriptive_text"), 
         htmlOutput("github_link"),
         htmlOutput("web_link")
  ),
  #slider input to select a player from the data (can only select 1 at a time) and style the slider accoring to css
  selectInput("player", "Player", players, multiple = F),
  #create the first row with the plot output
  div(
    #want to add some space between the plot and the text description
    style = "margin-top: 3em;",
    fluidRow(
      #set up the plot output and click elements
      column(12, plotOutput("percentiles", click="plot_click"))
    )
  ),
  #add the second row with the data table
  div(
    #want to add some space between the table and the text/plot output
    style = "margin-top: 3em;",
    #make a row with a data table output
    fluidRow(
      column(12, DT::dataTableOutput("table"))
    )
  ),
)

#server component of the Shiny app
server <- function(input, output) {
  #render the plot
  output$percentiles = renderPlot({
    percentiles %>%
      #filter by player 
      filter(Player %in% input$player) %>%
      #these columns aren't numeric so I don't want them for the plot
      select(-c("Player", "Position", "Draft Year", "Class", "School", "RSCI Ranking")) %>%
      #I want 2 columns (one with the column names and another with the corresponding percentiles) as opposed to 1 row with 19 columns
      pivot_longer(everything(), names_to = "Column", values_to = "Percentiles") %>%
      percentile_plot(input$player, color_hexes) 
  }, bg="transparent")
  
  
  #render a data table which by default will be this year's class basic info, but will change to a historical comp upon a user click
  output$table = DT::renderDataTable({
    #if there is no click yet display the current class's player information as the data table
    if (is.null(input$plot_click)) {
      output_df = player_stats %>%
        #only take specific columns
        select(c("Player", "Position", "Draft Age", "Class", "School", "Height", "Weight", "RSCI Ranking", "College OBPM",
                 "College DBPM", "College BPM"))
      #if there is a click then find the 3 most similar players at that position to the selected player in the selected category and return that as the table
    } else {
      #get all column names
      columns = colnames(percentiles)
      #remove columns not in plot
      #order columns so that the column you click sends a y value that can be used to index this vector so that the vector[y_input] = desired column
      columns = sort(columns[!columns %in% c("Player", "Position", "Draft Year", "Class", "School", "RSCI Ranking")])
      #get the column the user selected and store it so it can be passed to function (need to round to integer) that gets similar historical comps
      col = columns[round(input$plot_click$y)]
      #get x-axis user input (percentile value) and store it in variable to be passed to function that gets similar historical comps
      #round for a little more accuracy
      val = round(input$plot_click$x, 2)
      #get the player's position as percentiles were calculated according to position
      pos = percentiles[percentiles$Player == input$player, "Position"]
      #call the function with the appropriate information designated by the user input
      output_df = get_similar_players(val, col, pos)
    }
    #display the table according to whether user input has been fully given or not
    output_df
  })
  
  
  #this renders the first paragraph of descriptive text
  output$descriptive_text = renderText({
    paste("", descriptive_text, sep="\t")
  })
  
  #this provides a link to the code
  output$github_link = renderText({
    paste(github_link)
  })
  
  #this provides a link to my website homepage
  output$web_link = renderText({
    paste0("<br>", web_link)
  })
}

#start the shiny app
shinyApp(ui, server)







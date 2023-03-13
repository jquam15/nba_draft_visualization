# 2022 NBA Draft Visualization

Welcome to my 2022 NBA Draft Visualization repository! Here I take 2022 NBA Draft prospects and visualize their percentile rank **by position** compared to other prospects this year and in years past in an interactive Shiny application. Clicking data points in a plot will also provide similar historical players in my dataset for the selected category. Follow this [link](https://jquam15.shinyapps.io/nba_draft_visualization/) to check out my application! I would also highly encourage you to check out the rest of my work on my [website](https://jquam15.github.io/)!

The file **visualization.Rmd** includes the code used to make the shiny app as well as data manipulation and code testing functions that I used in the shiny app. The file **visualization.R** contains just necessary code to run the shiny app (excludes the extra stuff in visualization.Rmd).

I also used the following data files:

* **prospect_stats_2022.csv**: This file contains player information and statistics for 2022 NBA draft prospects.
* **visualization_data.csv**: This file contains historical data as well as this year's current prospects and contains the same features as the other file, but this time the values are percentile ranks by position instead of the raw statistics. These percentile ranks are used to create the visuals for each individual player. 

A couple of notes on the data: 

* College BPM was not tracked until 2010-2011, so that is the first year I have historical data for. 
* It is very challenging to find measurables on all NBA draft prospects, so the data set is limited as there are some players that just don't disclose that information publicly.
* Player were also not included in my historical data set if they did not post a 3rd year BPM in the NBA and/or did not play 75% of their teams games in college. I created this dataset with the intention of comparing this year's prospects to historical prospects that stuck for at least a little in the NBA (that's the goal of drafting a player after all). By default this means that players who played in the 2019-2020 and 2020-21 college seasons are not included in the **visualization_data.csv** dataset as they would be in their first and second NBA seasons (the 2022-23 season is not yet completed as of this writing). Overall, there are 172 historical players to compare to in the data. There are 51 2022 draft prospects also included in the data. 
* For prospects who have played multiple seasons in college, their stats are a weighted average of all their college seasons where recent seasons are weighted more heavily (a senior season is weighted much more highly than a freshman season).

Overall, the player visuals provide a general idea of a prospect's strengths and weaknesses compared to other prospects this year and prospects in the past. Similarly, although my historical data does not have every draft prospect in it (due to limitations in available data and my own criteria), the historical comparisons provide a general idea of some similar players at the selected category.

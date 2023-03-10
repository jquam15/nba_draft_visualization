# 2022 NBA Draft Visualization

Welcome to my 2022 NBA Draft Visualization repository. Here I take 2022 NBA Draft prospects and visualize their percentile rank by position compared to other prospects this year and in years past in an interactive Shiny application. I will post a link here in the near future that will take you to this application. I would also highly encourage you to check out the rest of my work on my [website](https://jquam15.github.io/)!

The file **visualization.Rmd** includes the code used to make the shiny app as well as data manipulation and code testing functions that I used in the shiny app. The file **visualization.R** contains just necessary code to run the shiny app (excludes the extra stuff in visualization.Rmd).

I also used the following data files:

* **prospect_stats_2022.csv**: this file contains player information and statistics for 2022 NBA draft prospects
* **visualization_data.csv**: this file contains historical data as well as this year's current prospects and contains the same features as the other file, but this time the values are percentile ranks by position 

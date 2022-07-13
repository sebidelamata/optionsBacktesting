# plotting our payoff functions (plotly)
# takes a profit df (2 columns profits and strikes)
# and a Title for the plot
lineplot_profit <- function(profit_df, title, option_chain_df){
  
  library(ggplot2)
  library(plotly)
  library(scales)
  library(wesanderson)
  
  profit_lineplot <- ggplot(
    data = profit_df,
    aes(
      x = possible_expiration_prices,
      y = possible_profits
    )
  ) +
    geom_line(color = wesanderson::wes_palette("Royal1")[3]) +
    ggtitle(title) +
    xlab("Possible Expiration Prices") +
    ylab("Profit (USD $)") +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = wes_palette("Darjeeling2")[5], color = wes_palette("Darjeeling2")[5]),
      plot.background = element_rect(fill = wes_palette("Darjeeling2")[5], color = wes_palette("Darjeeling2")[5]),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(color = wesanderson::wes_palette("Royal1")[3]),
      axis.text.y = element_text(color = wesanderson::wes_palette("Royal1")[3]),
      legend.position = "none",
      text = element_text(color = wesanderson::wes_palette("Royal1")[3])
    ) +
    scale_y_continuous(
      labels = scales::dollar_format(),
      limits = c(
        min(profit_df$possible_profits) - abs(0.2 * min(profit_df$possible_profits)),
        max(profit_df$possible_profits) + abs(0.2 * max(profit_df$possible_profits))
      )
    ) +
    scale_x_continuous(labels = scales::dollar_format()) +
    geom_hline(
      yintercept = 0,
      linetype = "dashed",
      color = wesanderson::wes_palette("Royal1")[3],
      size = 0.3
    ) +
    geom_vline(
      xintercept = option_chain_df$underlying_close[1],
      linetype = "dotted",
      color = "white",
      size = 0.075
    ) +
    scale_color_manual(values = wesanderson::wes_palette("Royal1")[3])
  
  profit_lineplot <- plotly::ggplotly(profit_lineplot)
  
  return(profit_lineplot)
  
}
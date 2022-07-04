

library(dplyr)
# these functions model how an option will pay out at a given strike price



# this first set is assuming a vanilla European-style option

# define intrinsic and extrinsic value for options
# Call Option Intrinsic Value=USC−CS
# where:
#   USC=Underlying Stock’s Current Price
# CS=Call Strike Price
call_intrinsic_value <- function(option_chain_df, strike_price){
  max(option_chain_df$underlying_close[1] - strike_price, 0) * 100
}



# now put option intrinsic value
# Put Option Intrinsic Value=PS−USC
put_intrinsic_value <- function(option_chain_df, strike_price){
  max(strike_price - option_chain_df$underlying_close[1], 0) * 100
}



# extrinsic value is simply option price minus intrinsic value
# first our call
call_extrinsic_value <- function(option_chain_df, strike_price){
  (100 * option_chain_df[option_chain_df$strike_price == strike_price & option_chain_df$contract_type == "C", "mid"]) - call_intrinsic_value(option_chain_df, strike_price)
}

# next our put
put_extrinsic_value <- function(option_chain_df, strike_price){
  (100 * option_chain_df[option_chain_df$strike_price == strike_price & option_chain_df$contract_type == "P", "mid"]) - put_intrinsic_value(option_chain_df, strike_price)
}


# The payoff for a call buyer at expiration date T is given by 
# max(0, ST – X)
call_buyer_payoff <- function(underlying_price_expiration, strike_price){
  
  # either zero or the difference in the strike and expiration
  max(0, underlying_price_expiration - strike_price)
  
}


# profit is equal to payoff minus the initial premium
call_buyer_profit <- function(underlying_price_expiration, strike_price, option_price){
  100 * (call_buyer_payoff(underlying_price_expiration, strike_price) - option_price)
}


# seller payoff is inverse of buyer payoff
call_seller_payoff <- function(underlying_price_expiration, strike_price){
  -call_buyer_payoff(underlying_price_expiration, strike_price)
}


# seller profit is seller payout plus what they originally received for selling the option
call_seller_profit <- function(underlying_price_expiration, strike_price, option_price){
  100 * (call_seller_payoff(underlying_price_expiration, strike_price) + option_price)
}


# put buyer payout is the opposite order (strike minus expiration) from the call buyer
put_buyer_payoff <- function(underlying_price_expiration, strike_price){
  
  # either zero or the strike prize minus expiration
  max(0, strike_price - underlying_price_expiration)

}


# put buyer profit equals payoff minus initial premium paid
put_buyer_profit <- function(underlying_price_expiration, strike_price, option_price){
  100 * (put_buyer_payoff(underlying_price_expiration, strike_price) - option_price)
}


# put seller payoff is inverse of buyer
put_seller_payoff <- function(underlying_price_expiration, strike_price){
  -put_buyer_payoff(underlying_price_expiration, strike_price)
}


# put seller profit is put seller payout plus initial premium received
put_seller_profit <- function(underlying_price_expiration, strike_price, option_price){
  100 * (put_seller_payoff(underlying_price_expiration, strike_price) + option_price)
}




# we first need to define this function which will return 
# dataframes for our profit functions further on
# create a data frame of two columns: some possible expiration prices, and possible profit outcomes
create_possible_profit_df <- function(option_chain_df, FUN, input_strike_price){
  
  # create a sequence of possible expiration prices
  possible_expiration_prices <- seq(
    0, 
    max(option_chain_df[,"strike_price"] * 2), 
    0.01
  )
  
  # run profit function across possible expiration prices
  possible_profits <- sapply(
    possible_expiration_prices, 
    function(x){
      FUN(x, strike_price = input_strike_price, option_chain_df[option_chain_df$strike_price == input_strike_price, "mid"])
    }
  )
  
  # turn these into a dataframe
  possible_profit_df <- data.frame(
    possible_profits,
    possible_expiration_prices
  )
  
  return(possible_profit_df)
}


# now we can model the long call
long_call_profit <- function(option_chain_df, long_call_strike_price){
  
  # filter option chain for calls
  option_chain_df <- option_chain_df[option_chain_df$contract_type == "C",]
  
  # we create our possible profit df
  long_call_possible_profit_df <- create_possible_profit_df(
    option_chain_df, 
    call_buyer_profit, 
    long_call_strike_price
  )
  
  # return our dataframe
  return(long_call_possible_profit_df)
  
}



# now we can model the short call
short_call_profit <- function(option_chain_df, short_call_strike_price){
  
  # filter option chain for calls
  option_chain_df <- option_chain_df[option_chain_df$contract_type == "C",]
  
  # we create our possible profit df
  short_call_possible_profit_df <- create_possible_profit_df(
    option_chain_df, 
    call_seller_profit, 
    short_call_strike_price
  )
  
  # return our dataframe
  return(short_call_possible_profit_df)
  
}



# now we can model the long put
long_put_profit <- function(option_chain_df, long_put_strike_price){
  
  # filter option chain for puts
  option_chain_df <- option_chain_df[option_chain_df$contract_type == "P",]
  
  # we create our possible profit df
  long_put_possible_profit_df <- create_possible_profit_df(
    option_chain_df, 
    put_buyer_profit, 
    long_put_strike_price
  )
  
  # return our dataframe
  return(long_put_possible_profit_df)
  
}



# now we can model the long put
short_put_profit <- function(option_chain_df, short_put_strike_price){
  
  # filter option chain for puts
  option_chain_df <- option_chain_df[option_chain_df$contract_type == "P",]
  
  # we create our possible profit df
  short_put_possible_profit_df <- create_possible_profit_df(
    option_chain_df, 
    put_seller_profit, 
    short_put_strike_price
  )
  
  # return our dataframe
  return(short_put_possible_profit_df)
  
}




# now we can model a call vertical
call_vertical_profit <- function(
    option_chain_df, 
    long_call_strike_price, 
    short_call_strike_price
    ){
  
  # long call profit df
  long_call <- long_call_profit(
    option_chain_df,
    long_call_strike_price
    )
  
  # short call profit df
  short_call <- short_call_profit(
    option_chain_df, 
    short_call_strike_price
    )
  
  # create our vertical profits which is the sum of the long and short legs
  call_vertical_profit_df <- data.frame(
    possible_expiration_prices = long_call$possible_expiration_prices,
    possible_profits = long_call$possible_profits + short_call$possible_profits
  )
  
  # return our dataframe
  return(call_vertical_profit_df)
  
}




# now we can model a put vertical
put_vertical_profit <- function(
    option_chain_df, 
    long_put_strike_price, 
    short_put_strike_price
    ){
  
  # long put profit df
  long_put <- long_put_profit(
    option_chain_df, 
    long_put_strike_price
    )
  
  # short put profit df
  short_put <- short_put_profit(
    option_chain_df, 
    short_put_strike_price
    )
  
  # create our vertical profits which is the sum of the long and short legs
  put_vertical_profit_df <- data.frame(
    possible_expiration_prices = long_put$possible_expiration_prices,
    possible_profits = long_put$possible_profits + short_put$possible_profits
  )
  
  # return our dataframe
  return(put_vertical_profit_df)
  
}


# map profits for an iron condor strategy (CAW!)
iron_condor_profit <- function(
    option_chain_df, 
    long_call_strike_price, 
    short_call_strike_price, 
    long_put_strike_price, 
    short_put_strike_price){
  
  temp_call_vertical_profit_df <- call_vertical_profit(
    option_chain_df, 
    long_call_strike_price, 
    short_call_strike_price
    )
  
  temp_put_vertical_profit_df <- put_vertical_profit(
    option_chain_df, 
    long_put_strike_price, 
    short_put_strike_price
  )
  
  # create our vertical profits which is the sum of the long and short legs
  iron_condor_profit_df <- data.frame(
    possible_expiration_prices = temp_call_vertical_profit_df$possible_expiration_prices,
    possible_profits = temp_call_vertical_profit_df$possible_profits + temp_put_vertical_profit_df$possible_profits
  )
  
  return(iron_condor_profit_df)
  
}




# let's create a profit function for holding 100 shares
buy_hundred_shares_profit <- function(option_chain_df){
  
  # create a sequence of possible closing prices
  possible_closing_prices <- seq(
    0, 
    max(option_chain_df[,"strike_price"]), 
    0.01
  )
  
  # apply our vector to the profit function
  buy_hundred_shares_profit <- sapply(
    possible_closing_prices, 
    function(closing_price){
      (closing_price * 100) - (option_chain_df$underlying_close[1] * 100) 
    }
    )
  
  buy_hundred_shares_profit_df <- data.frame(
    possible_closing_prices = possible_closing_prices,
    possible_profits = buy_hundred_shares_profit
  )
  
  # return our dataframe
  return(buy_hundred_shares_profit_df)
  
}



# let's create a covered call
covered_call_profit <- function(option_chain_df, short_call_strike_price){
  
  # short call profit df
  short_call <- short_call_profit(
    option_chain_df,
    short_call_strike_price
  )
  
  # 100 shares profit df
  long_hundred_shares <- buy_hundred_shares_profit(
  option_chain_df
  )
  
  covered_call_profit_df <- data.frame(
    possible_expiration_prices = short_call$possible_expiration_prices,
    possible_profits = short_call$possible_profits + long_hundred_shares$possible_profits
  )
  
}



# now we can model a bullish call diagonal
call_diagonal_profit <- function(
    long_call_option_chain_df, 
    long_call_strike_price,
    short_call_option_chain_df,
    short_call_strike_price
){
  
  # long call profit df
  long_call <- long_call_profit(
    long_call_option_chain_df,
    long_call_strike_price
  )
  
  # short call profit df
  short_call <- short_call_profit(
    short_call_option_chain_df, 
    short_call_strike_price
  )
  
  # merge different (probably) sized data frames so we can sum them
  call_diagonal_profit_df <- merge(
    long_call,
    short_call,
    by = "possible_expiration_prices",
    suffixes = c("long", "short")
  )
  
  
  
  # create our vertical profits which is the sum of the long and short legs
  call_diagonal_profit_df <- data.frame(
    possible_expiration_prices = call_diagonal_profit_df$possible_expiration_prices,
    possible_profits = call_diagonal_profit_df$possible_profitslong + call_diagonal_profit_df$possible_profitsshort
  )
  
  # return our dataframe
  return(call_diagonal_profit_df)
  
}




# plotting our payoff functions (plotly)
# takes a profit df (2 columns profits and strikes)
# and a Title for the plot
lineplot_profit <- function(profit_df, title){
  
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
      color = wesanderson::wes_palette("Royal1")[3]
      ) +
    scale_color_manual(values = wesanderson::wes_palette("Royal1")[3])
  
  profit_lineplot <- plotly::ggplotly(profit_lineplot)
                      
  return(profit_lineplot)
  
}



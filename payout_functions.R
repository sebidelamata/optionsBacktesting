
# these functions model how an option will pay out at a given strike price



# this first set is assuming a vanilla European-style option



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
    max(option_chain_df[,"strike_price"]), 
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







# plotting our payoff functions (plotly)
# takes a profit df (2 columns profits and strikes)
# and a Title for the plot
lineplot_profit <- function(profit_df, title){
  
  library(ggplot2)
  library(plotly)
  
  profit_lineplot <- ggplot(
    data = profit_df,
    aes(
      x = possible_expiration_prices,
      y = possible_profits
    )
  ) +
    geom_line() +
    ggtitle(title) +
    xlab("Possible Expiration Prices") +
    ylab("Profit (USD $)") +
    theme_minimal()
  
  profit_lineplot <- plotly::ggplotly(profit_lineplot)
                      
  return(profit_lineplot)
  
}



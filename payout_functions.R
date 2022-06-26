
# these functions model how an option will pay out at a given strike price

# this first set is assuming a vanilla European-style option

# The payoff for a call buyer at expiration date T is given by 
# max(0, ST – X)
call_buyer_payoff <- function(underlying_price_expiration, strike_price){
  max(0, underlying_price_expiration - strike_price)
}

# profit is equal to payoff minus the initial premium
call_buyer_profit <- function(underlying_price_expiration, strike_price, option_price){
  call_buyer_payoff(underlying_price_expiration, strike_price) - option_price
}

# seller payoff is inverse of buyer payoff
call_seller_payoff <- function(underlying_price_expiration, strike_price){
  -call_buyer_payoff(underlying_price_expiration, strike_price)
}

# seller profit is seller payout plus what they originally received for selling the option
call_seller_profit <- function(underlying_price_expiration, strike_price, option_price){
  call_seller_payoff(underlying_price_expiration, strike_price) + option_price
}

# put buyer payout is the opposite order (strike minus expiration) from the call buyer
put_buyer_payoff <- function(underlying_price_expiration, strike_price){
  max(0, strike_price - underlying_price_expiration)
}

# put buyer profit equals payoff minus initial premium paid
put_buyer_profit <- function(underlying_price_expiration, strike_price, option_price){
  put_buyer_payoff(underlying_price_expiration, strike_price) - option_price
}

# put seller payoff is inverse of buyer
put_seller_payoff <- function(underlying_price_expiration, strike_price){
  -put_buyer_payoff(underlying_price_expiration, strike_price)
}

# put seller profit is put seller payout plus initial premium received
put_seller_profit <- function(underlying_price_expiration, strike_price, option_price){
  put_seller_payoff(underlying_price_expiration, strike_price) + option_price
}
library("httr")
library("XML")

options(stringsAsFactors = FALSE)
search_criteria <- function(type, records_from =character(),fiscal_year=character(),agency_code =character(),status=character()){
  body <- paste0('<request><type_of_data>',type,'</type_of_data>')
  
  #Budget
  if (type == "Budget" ){
    if (length(records_from) > 0 ){
    body <- paste0(body,'<records_from>',toString(records_from),'</records_from><max_records>1000</max_records>')
  }
  
  body <- paste0(body,'<search_criteria>')
  if (length(fiscal_year) > 0 ){
    body <- paste0(body,'<criteria><name>year</name><type>value</type><value>',toString(fiscal_year),'</value></criteria>')
  }
  if (length(agency_code) > 0 ){
    body <- paste0(body,'<criteria><name>agency_code</name><type>value</type><value>',toString(agency_code),'</value></criteria>')
  }
  body <- paste0(body,'</search_criteria></request>')
  }
  else if (type %in% list("Spending","Payroll","Revenue")){
    if (length(records_from) > 0 ){
      body <- paste0(body,'<records_from>',toString(records_from),'</records_from><max_records>1000</max_records>')
    }
    
    body <- paste0(body,'<search_criteria>')
    if (length(fiscal_year) > 0 ){
      body <- paste0(body,'<criteria><name>fiscal_year</name><type>value</type><value>',toString(fiscal_year),'</value></criteria>')
    }
    if (length(agency_code) > 0 ){
      body <- paste0(body,'<criteria><name>agency_code</name><type>value</type><value>',toString(agency_code),'</value></criteria>')
    }
    body <- paste0(body,'</search_criteria></request>')}
  else if (type == 'Contracts'){
    if (length(records_from) > 0 ){
      body <- paste0(body,'<record_from>',toString(records_from),'</record_from><max_records>500</max_records>')
    }
    
    body <- paste0(body,'<search_criteria>')
    body <- paste0(body,'<criteria><name>status</name><type>value</type><value>',toString(status),'</value></criteria>')
    body <- paste0(body,'<criteria><name>category</name><type>value</type><value>all</value></criteria>')
    if (length(fiscal_year) > 0 ){
      body <- paste0(body,'<criteria><name>fiscal_year</name><type>value</type><value>',toString(fiscal_year),'</value></criteria>')
    }
    if (length(agency_code) > 0 ){
      body <- paste0(body,'<criteria><name>agency_code</name><type>value</type><value>',toString(agency_code),'</value></criteria>')
    }
    body <- paste0(body,'</search_criteria></request>')}
  else {
    print("wrong type name")
    break}
  return(body)
}


parse_data <- function(type,x,status=character()){
  BODY <- search_criteria(type,records_from = x,agency_code = "856",fiscal_year = "2019",status = status)
  res <- NULL
  while (is.null(res)){
    try(
      res <- POST(url = "https://www.checkbooknyc.com/api",body = BODY)
    )
  }
  
  data <- content(res,"text",encoding = "UTF-8")
  data <- substring(data,23,last = nchar(data))
  data <- xmlParseString(data)
  return(data[3]$result_records)
}


budget <- function(){
  i = 1
  data <- parse_data("Budget",i)
  total_record <- as.integer(xmlValue(data[1]$record_count))
  result <- c()
  while (total_record >0) {
    if (i != 1){
      data <- parse_data("Budget",i)
    }
    data <- data[2]$budget_transactions
    n_record <- xmlSize(data) 
    i = i + n_record
    total_record <- total_record - n_record
    while( n_record > 0){
      data_new <- data.frame(unlist(xmlToList(data[n_record]$transaction),recursive = FALSE))
      n_record <- n_record -1
      result <- rbind(result,data_new)
    }
    print("+")
  }
  return(result)
} 


spending <- function(){
  i = 1
  data <- parse_data("Spending",i)
  total_record <- as.integer(xmlValue(data[1]$record_count))
  result <- c()
  while (total_record >0) {
    if (i != 1){
      data <- parse_data("Spending",i)
    }
    data <- data[2]$spending_transactions
    n_record <- xmlSize(data) 
    i = i + n_record
    total_record <- total_record - n_record
    while( n_record > 0){
      data_new <- data.frame(t(sapply(xmlToList(data[n_record]$transaction),function(x) ifelse(is.null(x),"N/A",x))))
      n_record <- n_record -1
      result <- rbind(result,data_new)
    }
    print("+")
  }
  return(result)
} 

payroll <- function(){
  i = 1
  data <- parse_data("Payroll",i)
  total_record <- as.integer(xmlValue(data[1]$record_count))
  result <- c()
  while (total_record >0) {
    if (i != 1){
      data <- parse_data("Payroll",i)
    }
    data <- data[2]$payroll_transactions
    n_record <- xmlSize(data) 
    i = i + n_record
    total_record <- total_record - n_record
    while( n_record > 0){
      data_new <- data.frame(t(sapply(xmlToList(data[n_record]$transaction),function(x) ifelse(is.null(x),"N/A",x))))
      n_record <- n_record -1
      result <- rbind(result,data_new)
    }
    print("+")
  }
  return(result)
} 

revenue <- function(){
  i = 1
  data <- parse_data("Revenue",i)
  total_record <- as.integer(xmlValue(data[1]$record_count))
  result <- c()
  while (total_record >0) {
    if (i != 1){
      data <- parse_data("Revenue",i)
    }
    data <- data[2]$revenue_transactions
    n_record <- xmlSize(data) 
    i = i + n_record
    total_record <- total_record - n_record
    while( n_record > 0){
      data_new <- data.frame(t(sapply(xmlToList(data[n_record]$transaction),function(x) ifelse(is.null(x),"N/A",x))))
      n_record <- n_record -1
      result <- rbind(result,data_new)
    }
    print("+")
  }
  return(result)
} 

contract <- function(status){
  i = 1
  data <- parse_data("Contracts",i,status = status)
  total_record <- as.integer(xmlValue(data[1]$record_count))
  result <- c()
  while (total_record >0) {
    if (i != 1){
      data <- parse_data("Contracts",i,status = status)
    }
    data <- data[2]$contract_transactions
    n_record <- xmlSize(data) 
    i = i + n_record
    total_record <- total_record - n_record
    while( n_record > 0){
      data_new <- data.frame(t(sapply(xmlToList(data[n_record]$transaction),function(x) ifelse(is.null(x),"N/A",x))))
      n_record <- n_record -1
      result <- rbind(result,data_new)
    }
    print("+")
  }
  return(result)
} 

####################################
df_budget <- budget()
df_spending <- spending()
df_payroll <- payroll()
df_revenue <- revenue()
df_contract_active <- contract("active")
df_contract_registered <- contract("registered")
df_contract_pending <- contract("pending")

#write.csv(df_budget,file="budget.csv")


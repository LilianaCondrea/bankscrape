# frozen_string_literal: true

require 'watir'
require 'nokogiri'
require 'selenium-webdriver'
require 'json'
require 'pry'
require_relative 'account'
require_relative 'transaction'

# class operates over a bank account.

class Bendigobank


  def execute
   connect
   fetch_accounts
   fetch_transactions
    puts @accounts
    close
  end

  binding.pry
  browser = Watir::Browser.new(:chrome)
  browser.goto('https://demo.bendigobank.com.au')

  def login
    browser.button(:tabindex => "4", :class => "input_submit", :name => "customer_type",:value =>"personal").click
  end

  def fetch_accounts
    html = Nokogiri::HTML.fragment(browser.div(class: "content__wrapper").html)
  parse_accounts(html)
  end

  def parse_transactions(account, html)
    transactions = []
    date = html.at_css("[data-semantic-group] h3").text
    description = 'transaction'
    #description = html.at_css('h2.panel__header__label__primary[data-semantic="transaction-title"] span')
    amount = html.at_css('span.amount.debit[data-semantic="amount"]').text
    currency = 'USD'
    account_name = html.at_css("h6.grouped-list__group__heading").text
    transactions = ['date'=> date, 'description'=> description, 'amount'=> amount,'currency' => currency, 'account_name'=> account_name]
    transactions = Transactions.new( date,  description, amount,  currency, account_name )
    puts transactions.to_json
  end

  def parse_accounts(html)
    # Iterate accounts unsing css selectors
    accounts = []
    html.css('ol.grouped-list grouped-list--compact grouped-list--indent li').each do |html|
      name = html.at_css("h6.grouped-list__group__heading").text
      balance = html.at_css('[data-semantic="available-balance"]').text
      currency = 'USD'
      nature = 'credit card'
      transactions = Transactions.new( date,  description, amount,  currency, account_name )
      account = Accounts.new(name, balance, currency, nature, transactions) # create account here
      @accounts << account # add to accounts array
    end
  end


  def fetch_transactions
    @accounts.each do |account|
      fetch_transactions do
         two_months_ago = (Date.today - 60).strftime('%d/%m/%Y')
         today = Date.today.strftime('%d/%m/%Y')
         fetch_transactions(@accounts,from_date: two_months_ago, to_date: today)
        parse_transactions(account, html)
      end
    end
  end


  def close
  @browser.close
  end
end

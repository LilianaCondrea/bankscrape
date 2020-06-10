# frozen_string_literal: true

require 'watir'
require 'nokogiri'
require 'json'
require 'pry'
require_relative 'account'
require_relative 'transaction'

# class operates over a bank account.

class Bendigobank

  def initialize( )
  @accounts = []
  end

  def execute
   connect
   fetch_accounts
   fetch_transactions
   JSON.pretty_generate({"accounts": @accounts})
  end

  BANK_URL='https://demo.bendigobank.com.au'
  #binding.pry
  def connect
    @browser = Watir::Browser.new(:chrome)
    @browser.goto(BANK_URL)
    @browser.button(value: 'personal').click
  end

  def fetch_accounts
  html = Nokogiri::HTML.fragment(@browser.div(class: "content__wrapper").html)
  parse_accounts(html)
  end

    def fetch_transactions
    @accounts.each do |account|
      now = Date.today
      months_ago = (now - 60)
      end
    end

    def parse_transactions(account, html)
      date = html.at_css("h3").text
      description = 'transaction'
      amount = (html.at_css('span.amount.debit').text).gsub(/[^\d^.]/, '').to_f
      currency = 'USD'
      account_name = html.at_css("h6").text
      transactions = ['date' => date , 'description' => description, 'amount' => amount, 'currency' => currency, 'account_name' => account_name]
      @transactions << transactions
    end

  def parse_accounts(html)
    # Iterate accounts unsing css selectors
    html.css('ol.grouped-list grouped-list--compact grouped-list--indent li').each do |html|
      name  = html.css("h6")[0].text
      balance = html.at_css('dd span[aria-label]').text.gsub(/[^\d^.]/, '').to_f
      currency = 'USD'
      nature = 'credit card'
      transactions = Transactions.new( date,  description, amount,  currency, account_name )
      @accounts = ['name' => name , 'balance' => balance, 'currency' => currency, 'nature' => nature, 'transactions' => transactions]
    end
  end

  example = Bendigobank.new
  example.execute
end

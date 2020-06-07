# frozen_string_literal: true

require 'watir'
require 'nokogiri'
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
  end


  def connect
    @browser = Watir::Browser.new(:chrome, 'goog:chromeOptions' => { detach: true })
    @browser.goto 'https://demo.bendigobank.com.au'
    @browser.button(css: '.input_submit').click
  end

  def fetch_accounts
  # fetch html data using nokogiri, take only fragment of html.
  html = Nokogiri::HTML.fragment(@browser.div(class: 'content__content content__content--desktop').html)
  parse_accounts(html)
  end


  def parse_transactions(account, html)
    #@date = html.at_css('h3.grouped-list__group__heading[data-semantic="activity-group-heading"]').text
    @date = html.at_css("h3.grouped-list__group__heading")
    @description = html.at_css('h2.panel__header__label__primary[data-semantic="transaction-title"] span')
    @amount = html.at_css('span.amount.debit[data-semantic="amount"]')
    @currency = 'USD'
    @account_name='account1'

    # @transactions = Transaction.new( @date, @description,  @amount,  @currency,  @account_name) # create account here
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

  def parse_accounts(html)
    # Iterate accounts unsing css selectors
    @accounts = []
    html.css('ol.grouped-list grouped-list--compact grouped-list--indent li').each do |html|
      @name = 'account1'
      @balance = html.at_css('span[data-semantic="available-balance"]')
      @currency = 'USD'
      @nature = 'credit card'
      @transactions = Transactions.new(@date,  @description, @amount,  @currency, @account_name )
      @transactions = ['date'=> @date, 'description'=> @description, 'amount'=> @amount,'currency' => @currency, 'account_name'=> @account_name]
      @account = Accounts.new(@name, @balance, @currency, @nature) # create account here
      @accounts << @account # add to accounts array
    end
    @accounts
  end
end

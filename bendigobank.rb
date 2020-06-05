# frozen_string_literal: true

require 'watir'
require 'nokogiri'
require 'json'
require 'pry'
require_relative 'account'
require_relative 'transaction'

# class operates over a bank account.

class Bendigobank

   @browser = Watir::Browser.new(:chrome, 'goog:chromeOptions' => { detach: true })


  def execute
   connect
   fetch_accounts
   fetch_transactions
   show_result
  end

  binding.pry
  def connect
    @browser.goto 'https://demo.bendigobank.com.au'
    @browser.button(css: '.input_submit').click
  end

  def fetch_accounts
  # fetch html data using nokogiri, take only fragment of html.
  html = Nokogiri::HTML.fragment(@browser.div(class: 'accounts-list').html)
  puts html
  parse_accounts(html)
  end

  def fetch_transactions
  @accounts.each do |account|
    two_months_ago = (Date.today - 60).strftime('%d/%m/%Y')
    today = Date.today.strftime('%d/%m/%Y')
    StatementPage.new(@browser)
                 .fetch_transactions_into(@accounts,
                                          from_date: two_months_ago,
                                          to_date: today)
    parse_transactions(account, html)
    end
  end

  def parse_accounts(html)
    # Iterate accounts unsing css selectors
    html.css('ol.grouped-list__group__items li').each do |html|
      name = html.at_css('h6[data-semantic="account-group-heading"]')
      balance = html.at_css('span[data-semantic="available-balance"]')
      currency =html.at_css('span[data-semantic="available-balance"][0]')
      nature = html.at_css('div._3jAwGcZ7sr _5KR4Am_fPD')
      transaction = []
      account = Account.new(name, balance, currency, nature, transactions ) # create account here
      @accounts << account # add to accounts array
    end
  end

  def parse_transactions(account, html)
    # parse transactions here
    html.css('ol.grouped-list grouped-list--compact grouped-list--indent li').each do |html|
      date = html.at_css('h3[data-semantic="activity-group-heading"]')
      description = html.at_css('h2[data-semantic="transaction-title"]')
      amount = html.at_css('span.amount.debit')

      transaction = Transaction.new(date, description, amount) # create account here
      @transactions << transaction
    end
  end

  def show_result
     
  end
end

require 'watir'
require 'nokogiri'
require_relative 'accountclass'
require_relative 'transactionclass'
require_relative 'nokogem'
require_relative 'login'

# Operate over a bank account.
#
class Scraper
  URL = 'https://demo.bendigobank.com.au'

  def initialize(browser: :chrome)
    @accounts = Accounts.new
    @browser = Watir::Browser.new browser
  end

  # Navigate to bank account, fetch accounts and transactions.
  #
  def fetch_accounts()
      accodashboard.each do |r|
        link = r.link.text
        r.link.click
        block.call link
        back
      end
    end

    def fetch_transactions()
      safe_click_on transdashboard
      block.call
      back
    end
    private

     def accdashboard
        @browser.div(class: '_2GeM33pzCD accounts-list')
     end

     def transdashboard
       @browser.div(class: 'activity-container _2Ls5J__6Ag')
     end

     def back
       @browser.back
     end

  def login
    LoginPage.new(@browser, URL).login
  end

  def fetch_accountss
      AccountPage.new(@browser).fetch_account_into(name, @accounts)
    end
  end

  def fetch_transactions
      two_months_ago = (Date.today - 60).strftime('%d/%m/%Y')
      today = Date.today.strftime('%d/%m/%Y')
      StatementPage.new(@browser)
                   .fetch_transactions_into(@accounts,
                                            from_date: two_months_ago,
                                            to_date: today)
    end
  

  def run
    login
    fetch_accounts()
    fetch_transactions()
    puts @accounts
    close
  end

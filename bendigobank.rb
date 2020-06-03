require 'watir'
require 'nokogiri'
require 'pry'
require_relative 'account'
require_relative 'transaction'

# Operate over a bank account.
class Bendigobank

  def execute
    binding.pry
    login
    fetch_accounts
    fetch_transactions
    show_result
  end

  def login
    # here you log in to the bank
    browser = Watir::Browser.new(:chrome,'goog:chromeOptions' => {detach: true})
    browser.goto("https://demo.bendigobank.com.au")
    #sign in script
    browser.button(:tabindex => "4", :class => "input_submit",
      :name => "customer_type",:value=>"personal").click
  end

  def fetch_accounts
  # fetch html data using nokogiri, take only fragment of html.
  html = Nokogiri::HTML.fragment(browser.div(class: "accounts-list").html)
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
    html.css("ol.grouped-list__group__items li").each do |li|
      name = html.at_css("h6[data-semantic='account-group-heading']").text
      balance = html.at_css("span[data-semantic='available-balance']").text
      currency =html.at_css("span[data-semantic='available-balance'][0]").text
      nature = html.at_css("div._3jAwGcZ7sr _5KR4Am_fPD").text

      account = Account.new(name, balance, currency, nature ) # create account here
      @accounts << account # add to accounts array
    end
  end

  def parse_transactions(account, html)
    # parse transactions here
    html.css("ol.grouped-list grouped-list--compact grouped-list--indent li").each do |li|
      date = html.at_css("h3[data-semantic='activity-group-heading']").text
      description = html.at_css("h2[data-semantic='transaction-title']").text
      amount =html.at_css("span.amount.debit").text

      transaction = Transaction.new(date, description, amount ) # create account here
      @transactions << transaction
  end
  end
end

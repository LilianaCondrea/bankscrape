require 'nokogiri'

# Page object class for `account` pages.

class AccountPage
  def initialize(browser)
    @browser = browser
  end

  def fetch_account_into(name, container)

    html = Nokogiri::HTML(@browser.html)
    account_info = html.css('div.yBcmat9coi h2')
    currency, balance = html.at_css('._2tzPNu1unf _22kXFRwS9J span').content.split
    balance = balance.to_f
    nature = html.css('')
    container << Account.new(name, currency, balance, nature)
  end
end

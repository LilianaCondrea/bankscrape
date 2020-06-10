# frozen_string_literal: true

require 'watir'
require 'nokogiri'
require 'json'
require 'pry'
require_relative 'account'
require_relative 'transaction'

# class operates over a bank account.

class Bendigobank

  BANK_URL='https://demo.bendigobank.com.au'

  def execute
   connect
   fetch_accounts
   fetch_transactions
   show_result
  end


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
      to_d = Time.new().to_datetime
      from_d = to_d << 2

      from_d = date_format(from_d) #start date
      to_d = date_format(to_d) #end date


      @browser.ol(class: 'grouped-list__group__items').each_with_index do |li,i|
      li.a(class: 'panel--hover').click
      @browser.i(class: 'ico-nav-bar-filter_16px').click
      @browser.a(class: 'panel--bordered__item').click
      @browser.ul(class: 'radio-group').li(index: 8).click
      @browser.text_field(name: 'fromDate').set(from_d)
      @browser.text_field(name: 'toDate').set(to_d)
      @browser.button(class: 'button--primary').click
      @browser.button(class: 'button--primary').click
      until @browser.p(text: "No more activity").present?
      end
    end

    html = Nokogiri::HTML.fragment(@browser.div(class: 'activity-container').html)
    account_name = @browser.h2(class: 'yBcmat9coi').text

    parse_transactions(html,account_name)
     @accounts["transactions"] = @transaction
    end
 end

 def parse_accounts(html)
    @accounts = []

     html.css('.grouped-list__group__items li').each do |li|
      name = li.css('._3jAwGcZ7sr').text
      balance = li.css('.S3CFfX95_8').text
      currency = balance[19]
      balance = balance.gsub(/[^\d^.]/, '').to_f
      nature = 'card'
      transactions = []

      @accounts.push(Accounts.new(name,currency,balance,nature,transactions).to_hash)
     end
     return @accounts
   end

    def parse_transactions(html,account_name)
    @transaction = []

    html.css('.grouped-list--indent').css('.grouped-list__group').each do |li|
      date = li.css('h3').text
      li.css('.grouped-list__group__items li').each do |li|
         description = 'transaction'
         amount = li.css('span.amount.debit').text
         amount = amount.gsub(/[^\d^.]/, '').to_f
         currency = 'USD'
         @transaction.push(Transactions.new(date,description,amount,currency,account_name).to_hash)
       end
    end
    return @transaction
    end

    def date_format(date)
      case
      when date.day < 31 && date.month < 12 && date.year < 10 
        date = "0" + date.day.to_s + "/" + "0" + date.month.to_s + "/" + date.year.to_s
      else
        date = date.day.to_s + "/" + date.month.to_s + "/" + date.year.to_s
      end
    end


     def show_result
     puts JSON.pretty_generate("accounts":@accounts)
    end



bank = Bendigobank.new
bank.execute

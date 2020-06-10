# frozen_string_literal: true

require 'rspec'
require 'Nokogiri'
require_relative 'account'
require_relative 'transaction'

html_account = Nokogiri::HTML(File.read('accounts.html'))
html_transaction = Nokogiri::HTML(File.read('transactions.html'))
accounts = Bendigobank.parse_accounts(html_account)
transactions = Bendigobank.parse_transactions(html_transaction,"account_name")

describe "accounts counting" do
    it 'if number of accounts is 5 returns true' do
      expect(accounts.count).to eq(5)
    end
  end

  describe "transactions counting" do
    it 'returns true if number of transctions is 15' do
      expect(transactions.count).to eq(15)
    end
  end

  describe " account validation " do
    it 'returns true if accounts[0] is valid' do
      expect(accounts.first.to_h).to eq(
        {
          "name"=>"Justin Nguyen",
          "currency"=>"$",
          "balance"=>1959.90,
          "nature"=>"card",
          "transactions"=>[]
        }
      )
    end
  end

  describe "transaction validation" do
    it 'returns true if transactions[0] is valid' do
      expect(transactions.first.to_h).to eq(
        {
          "date"=>"May 27, 2020",
          "description"=>"00001792196502",
          "amount"=> 15000.00,
          "currency"=>"$",
          "account_name"=>"account_name"
        }
      )
    end
 end

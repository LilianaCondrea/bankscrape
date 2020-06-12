# frozen_string_literal: true

require 'rspec'
require 'json'
require 'nokogiri'
require_relative 'account'
describe Bendigobank do
    html_account = Nokogiri::HTML(File.read('accounts.html'))
    html_transaction = Nokogiri::HTML(File.read('transactions.html'))

    accounts = Bendigobank.parse_accounts(html_account)
    transactions = Bendigobank.parse_transactions(html_transaction,"account_name")

  describe "#parse_accounts" do
    it 'show example for account object' do
      expect(accounts.count).to eq(5)
      expect(accounts.first.to_hash).to eq(
        {
          "name"         => "Demo Account",
          "currency"     => "USD",
          "balance"      => 1959.90,
          "nature"       => "account",
          "transactions" => []
        }
      )
    end
  end

  describe "#parse_transactions" do
    it 'show example for account object' do
      expect(accounts.count).to eq(5)
      expect(accounts.first.to_hash).to eq(
        {
          "date"         => "2020",
          "description"  => 'transaction',
          "amount"       => 10.00,
          "currency"     => "USD",
          "account_name" => "Demo Account"
        }
      )
    end
  end
end

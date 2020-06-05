# frozen_string_literal: true

require 'rspec'
require 'json'
require 'nokogiri'
require_relative 'account'
require_relative 'transaction'
describe Account do
  Nokogiri::HTML(File.read('accounts.html'))
  Nokogiri::HTML(File.read('transactions.html'))
  accounts = Account.parse_accounts(html)
  expect(accounts.count).to eq(2)
  expect(accounts[0].to_hash).to eq(
    {
      'name' => 'Example Account',
      'currency' => 'USD',
      'balance' => 8888.99,
      'nature' => 'Account',
      'transactions' => []
    }
  )
    expect(transactions.count).to eq(2)
    expect(transactions[0].to_hash).to eq(
  {
    'date' => '2019-12-31',
    'description' => 'example description',
    'amount' => -8.99,
    'currency' => 'USD',
    'account_name' => 'Example Account'
  }
    )

end

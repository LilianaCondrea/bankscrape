# frozen_string_literal: true

require 'rspec'
require 'Nokogiri'
require_relative 'account'
require_relative 'transaction'
describe Account do
  html     = Nokogiri::HTML.fragment(browser.div(class: 'accounts-list').html)
  accounts = Account.parse_accounts(html)
  expect(accounts.count).to eq(2)
  expect(accounts[0].to_hash).to eq(
    {
      name: item.find_element(class: 'grouped-list__group__heading').text,
      balance: item.find_element(class: '_1vKeQVO7xz S3CFfX95_8').text,
      nature: item.find_element(class: 'visuallyhidden').span
    }
  )

end

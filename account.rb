# frozen_string_literal: true

require_relative 'transaction'

# Stores data related to a single account.
#
class Account
  attr_reader :name, :balance, :currency, :nature, :transactions

  def initialize(name, balance, currency, nature)
    @name = name
    @balance = balance
    @currency = currency
    @nature = nature
    @transactions = Transactions.new
  end

  def to_s
    to_hash.to_s
  end

  def to_hash
    {
      name: @name, balance: @balance, currency: @currency, nature: @nature,
      transactions: @transactions.to_hash
    }
  end
end

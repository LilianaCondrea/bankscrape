# frozen_string_literal: true

require_relative 'transaction'

# Stores data related to a single account.
#
class Accounts
  attr_reader :name, :balance, :currency, :nature, :transactions

  def initialize(name, balance, currency, nature, transactions)
    @name = name
    @balance = balance
    @currency = currency
    @nature = nature
    @transactions = transactions
    transactions = Transactions.new(date,  description, amount,  currency, account_name)
  end

  def to_hash
    hash{
      name: @name, balance: @balance, currency: @currency, nature: @nature,
      transactions: @transactions.to_hash
    }
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
  end

  def to_s
    to_hash.to_s
  end
end

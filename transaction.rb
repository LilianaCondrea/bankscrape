# frozen_string_literal: true

# Class stores data related to a single transaction.

class Transaction
  attr_reader :date, :description, :amount, :currency, :account_name

  def initialize(date, description, amount, currency, account_name)
    @date = date
    @description = description
    @amount = amount
    @currency = currency
    @account_name = account_name
  end

  def to_s
    to_hash.to_s
  end

  def to_hash
    { date: @date,
      description: @description,
      amount: @amount,
      currency: @currency,
      account_name: @account_name }
  end
end

class Accounts
  attr_accessor :name, :currency, :balance, :nature, :transactions

  def initialize(name,currency,balance,nature,transactions)
    @name = name
    @currency = currency
    @balance = balance
    @nature = nature
    @transactions = transactions
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end

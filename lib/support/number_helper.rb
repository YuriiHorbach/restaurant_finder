module NumberHelper
  def number_to_currency(value)
    sprintf("$%.2f", value.to_f)
  end
end

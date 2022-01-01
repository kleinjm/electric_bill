# frozen_string_literal: true

class Bill
  attr_accessor(
    :start_date,
    :end_date,
    :total_kwh,
    :total_electric_cost,
    :basement_electric_cost,
    :main_electric_cost,
    :total_gas_cost
  )

  def print
    [
      "Start date: #{start_date}",
      "End date: #{end_date}",
      "Total KwH: #{total_kwh}",
      "KwH Cost: $#{kwh_cost}",
      "Total Electric Cost: $#{total_electric_cost}",
      "Total Gas Cost: $#{total_gas_cost}",
      "Upper Electric Cost: $#{upper_electric_cost}",
      "Split Upper Electric Cost: $#{split_upper_electric_cost}",
      "Split Gas Cost: $#{split_gas_cost}",
      "",
      "Main Electric Cost: $#{main_electric_cost}",
      "Basement Electric Cost: $#{basement_electric_cost}",
      "Split Upper Gas and Electric Cost: $#{split_upper_gas_and_electric_cost}"
    ].each { |line| puts line }
  end

  def kwh_cost
    # go to 4 decimal places because it adds up
    (total_electric_cost / total_kwh).round(4)
  end

  def upper_electric_cost
    (total_electric_cost - (basement_electric_cost + main_electric_cost)).
      round(2)
  end

  def split_upper_electric_cost
    (upper_electric_cost / 2.to_f).round(2)
  end

  def split_gas_cost
    (total_gas_cost / 2.to_f).round(2)
  end

  def split_upper_gas_and_electric_cost
    (split_upper_electric_cost + split_gas_cost).round(2)
  end
end

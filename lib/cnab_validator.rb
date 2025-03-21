module CnabValidator
  def self.valid_date?(date_str)
    Date.strptime(date_str, "%Y%m%d") rescue false
  end

  def self.valid_value?(value_str)
    value_str.match?(/^\d{10}$/) && value_str.to_f > 0
  end

  def self.valid_cpf?(cpf)
    cpf.match?(/^\d{11}$/)
  end

  def self.valid_card?(card)
    card.match?(/^\d{4}\*{4}\d{4}$/)
  end

  def self.valid_time?(time_str)
    Time.strptime(time_str, "%H%M%S") rescue false
  end
end

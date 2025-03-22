class CnabParserService
  TRANSACTION_TYPES = {
    1 => { description: "Débito", multiplier: 1 },
    2 => { description: "Boleto", multiplier: -1 },
    3 => { description: "Financiamento", multiplier: -1 },
    4 => { description: "Crédito", multiplier: 1 },
    5 => { description: "Recebimento Empréstimo", multiplier: 1 },
    6 => { description: "Vendas", multiplier: 1 },
    7 => { description: "Recebimento TED", multiplier: 1 },
    8 => { description: "Recebimento DOC", multiplier: 1 },
    9 => { description: "Aluguel", multiplier: -1 }
  }.freeze

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    result = nil
    ActiveRecord::Base.transaction do
      begin
        unless validate_file[:success]
          return { success: false, errors: "File is empty or contains no valid data" }
        end

        File.foreach(@file_path).with_index(1) do |line, line_number|
          next if line.strip.empty?

          validate_line!(line, line_number)

          transaction_data = parse_line(line)
          store_owner = StoreOwner.find_or_create_by!(name: transaction_data[:owner_name])
          store = Store.find_or_create_by!(name: transaction_data[:store_name], store_owner: store_owner)

          transaction_data.except!(:owner_name, :store_name)

          Transaction.create!(transaction_data.merge(store: store))
        end
        return { success: true }
      rescue Errno::ENOENT => e
        result = { success: false, errors: "File not found: #{e.message}" }
      rescue ArgumentError => e
        result = { success: false, errors: "Invalid data format: #{e.message}" }
        raise ActiveRecord::Rollback
      rescue ActiveRecord::RecordInvalid => e
        result = { success: false, errors: "Database error: #{e.message}" }
        raise ActiveRecord::Rollback
      rescue StandardError => e
        result = { success: false, errors: "An unexpected error occurred: #{e.message}" }
        raise ActiveRecord::Rollback
      end
    end
    result
  end

  private

  def validate_file
    unless File.exist?(@file_path)
      return { success: false, errors: "File not found" }
    end

    lines = File.readlines(@file_path).map(&:strip).reject(&:empty?)

    if lines.empty?
      return { success: false, errors: "File is empty or contains no valid data" }
    end

    { success: true }
  end

  def validate_line!(line, line_number)
    transaction_type = line[0].to_i
    unless (1..9).include?(transaction_type)
      raise ArgumentError, "Line #{line_number} is invalid: Invalid transaction type '#{transaction_type}'"
    end

    unless CnabValidator.valid_date?(line[1..8])
      raise ArgumentError, "Line #{line_number} is invalid: Invalid date '#{line[1..8]}'"
    end

    unless CnabValidator.valid_value?(line[9..18])
      raise ArgumentError, "Line #{line_number} is invalid: Invalid value '#{line[9..18]}'"
    end

    unless CnabValidator.valid_cpf?(line[19..29])
      raise ArgumentError, "Line #{line_number} is invalid: Invalid CPF '#{line[19..29]}'"
    end

    unless CnabValidator.valid_card?(line[30..41])
      raise ArgumentError, "Line #{line_number} is invalid: Invalid card '#{line[30..41]}'"
    end

    unless CnabValidator.valid_time?(line[42..47])
      raise ArgumentError, "Line #{line_number} is invalid: Invalid time '#{line[42..47]}'"
    end

    owner_name = line[48..61].strip
    if owner_name.empty?
      raise ArgumentError, "Line #{line_number} is invalid: Owner name cannot be empty"
    end

    store_name = line[62..80].strip
    if store_name.empty?
      raise ArgumentError, "Line #{line_number} is invalid: Store name cannot be empty"
    end
  end

  def parse_line(line)
    transaction_type = line[0].to_i
    multiplier = TRANSACTION_TYPES[transaction_type][:multiplier]

    date, time = extract_date_and_time(line)

    {
      transaction_type: transaction_type,
      date: date,
      value: line[9..18].to_f / 100 * multiplier,
      cpf: line[19..29].strip,
      card: line[30..41].strip,
      time: time,
      owner_name: line[48..61].strip,
      store_name: line[62..80].strip
    }
  end

  def extract_date_and_time(line)
    part_date = Date.strptime(line[1..8], "%Y%m%d")
    part_time = Time.strptime(line[42..47], "%H%M%S")

    datetime = DateTime.new(
      part_date.year,
      part_date.month,
      part_date.day,
      part_time.hour,
      part_time.min,
      part_time.sec
    )

    date = datetime.to_date
    time = datetime.to_time

    [ date, time ]
  end
end

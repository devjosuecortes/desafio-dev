class CnabTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_file_presence, only: :create

  def new
    @transactions_by_store = fetch_transactions
  end

  def create
    file_path = save_uploaded_file(params[:file])

    if file_path
      process_file(file_path)
    else
      flash[:error] = "Erro ao salvar o arquivo."
    end

    redirect_to new_cnab_transaction_path
  end

  private

  def validate_file_presence
    return unless params[:file].blank?

    flash[:error] = "Nenhum arquivo selecionado."
    redirect_to new_cnab_transaction_path
  end

  def save_uploaded_file(file)
    filename = "#{SecureRandom.uuid}_#{file.original_filename}"
    filepath = Rails.root.join("tmp", "uploads", filename)

    FileUtils.mkdir_p(filepath.dirname)

    File.open(filepath, "wb") { |f| f.write(file.read) }
    filepath.to_s
  rescue StandardError => e
    Rails.logger.error("Erro ao salvar arquivo: #{e.message}")
    nil
  end

  def process_file(file_path)
    result = CnabParserService.new(file_path).call
    if result[:success]
      flash[:success] = "Arquivo processado com sucesso!"
    else
      flash[:error] = result[:errors]
    end
  rescue StandardError => e
    Rails.logger.error("Erro no processamento: #{e.message}")
    flash[:error] = "Erro inesperado ao processar o arquivo."
  ensure
    File.delete(file_path) if File.exist?(file_path)
  end

  def fetch_transactions
    Store.includes(:transactions).map do |store|
      {
        name: store.name,
        owner: store.store_owner.name,
        transactions: store.transactions,
        total_balance: store.transactions.sum(:value)
      }
    end
  end
end

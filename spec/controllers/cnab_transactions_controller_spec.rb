require 'rails_helper'

RSpec.describe CnabTransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:store) { create(:store, name: "Store 1", store_owner: create(:store_owner)) }
  let(:valid_file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/CNAB.txt"), "text/plain") }
  let(:invalid_file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/CNAB_INVALID_DATE.txt"), "text/plain") }

  before { sign_in user }

  describe "GET #new" do
    it "assigns transactions grouped by store" do
      create_list(:transaction, 3, store: store)
      get :new
      expect(assigns(:transactions_by_store)).not_to be_empty
      expect(assigns(:transactions_by_store).map { |t| t[:name] }).to include("Store 1")
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "when no file is selected" do
      it "sets an error flash message and redirects" do
        post :create, params: { file: nil }
        expect(flash[:error]).to eq("Nenhum arquivo selecionado.")
        expect(response).to redirect_to(new_cnab_transaction_path)
      end
    end

    context "when a valid file is uploaded" do
      before do
        allow(CnabParserService).to receive(:new).and_return(double(call: { success: true }))
      end

      it "processes the file successfully" do
        post :create, params: { file: valid_file }
        expect(flash[:success]).to eq("Arquivo processado com sucesso!")
        expect(response).to redirect_to(new_cnab_transaction_path)
      end
    end

    context "when the file processing fails" do
      before do
        allow(CnabParserService).to receive(:new).and_return(double(call: { success: false, errors: "Invalid data format" }))
      end

      it "sets an error flash message" do
        post :create, params: { file: invalid_file }
        expect(flash[:error]).to eq("Invalid data format")
        expect(response).to redirect_to(new_cnab_transaction_path)
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(CnabParserService).to receive(:new).and_raise(StandardError.new("Unexpected error"))
      end

      it "sets an unexpected error flash message" do
        post :create, params: { file: valid_file }
        expect(flash[:error]).to eq("Erro inesperado ao processar o arquivo.")
        expect(response).to redirect_to(new_cnab_transaction_path)
      end
    end

    context "when the file cannot be saved" do
      before do
        allow_any_instance_of(CnabTransactionsController).to receive(:save_uploaded_file).and_return(nil)
      end

      it "sets an error flash message" do
        post :create, params: { file: valid_file }
        expect(flash[:error]).to eq("Erro ao salvar o arquivo.")
        expect(response).to redirect_to(new_cnab_transaction_path)
      end
    end
  end
end

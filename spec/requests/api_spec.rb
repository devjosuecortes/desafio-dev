require 'swagger_helper'

RSpec.describe 'API', type: :request do
  # path '/users/sign_in' do
  # post 'User Login' do
  #   tags 'Authentication'
  #   consumes 'application/json'
  #   produces 'application/json'
  #   parameter name: :user, in: :body, schema: {
  #     type: :object,
  #     properties: {
  #       email: { type: :string, example: 'user@example.com' },
  #       password: { type: :string, example: 'password123' }
  #     },
  #     required: %w[email password]
  #   }

  #   response '200', 'Login successful' do
  #     let(:user) { { email: 'user@example.com', password: 'password123' } }
  #     run_test!
  #   end

  #   response '401', 'Unauthorized' do
  #     let(:user) { { email: 'wrong@example.com', password: 'wrong' } }
  #     run_test!
  #   end
  # end
  # end

  # path '/users/sign_up' do
  #   post 'User Signup' do
  #     tags 'Authentication'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     parameter name: :user, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         name: { type: :string, example: 'John Doe' },
  #         email: { type: :string, example: 'user@example.com' },
  #         password: { type: :string, example: 'password123' },
  #         password_confirmation: { type: :string, example: 'password123' }
  #       },
  #       required: %w[name email password password_confirmation]
  #     }

  #     response '201', 'User created' do
  #       let(:user) { { name: 'John Doe', email: 'user@example.com', password: 'password123', password_confirmation: 'password123' } }
  #       run_test!
  #     end

  #     response '422', 'Validation errors' do
  #       let(:user) { { name: '', email: 'invalid', password: '123', password_confirmation: '456' } }
  #       run_test!
  #     end
  #   end
  # end

  # path '/dashboard' do
  #   get 'Dashboard' do
  #     tags 'Dashboard'
  #     produces 'application/json'
  #     security [bearerAuth: []]

  #     response '200', 'Dashboard loaded' do
  #       run_test!
  #     end
  #   end
  # end

  # path '/cnab_transactions/new' do
  #   get 'CNAB Upload Form' do
  #     tags 'CNAB'
  #     produces 'text/html'
  #     security [bearerAuth: []]

  #     response '200', 'Form displayed' do
  #       run_test!
  #     end
  #   end
  # end

  # path '/cnab_transactions' do
  #   post 'Upload CNAB File' do
  #     tags 'CNAB'
  #     consumes 'multipart/form-data'
  #     security [bearerAuth: []]

  #     parameter name: :file, in: :formData, type: :file, required: true, description: 'CNAB file to upload'

  #     response '302', 'File uploaded successfully' do
  #       run_test!
  #     end

  #     response '422', 'Invalid file' do
  #       run_test!
  #     end
  #   end
  # end

  # path '/users/sign_out' do
  #   delete 'User Logout' do
  #     tags 'Authentication'
  #     produces 'application/json'
  #     security [bearerAuth: []]

  #     response '204', 'Logged out' do
  #       run_test!
  #     end
  #   end
  # end
end

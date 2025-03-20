require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: 'Fulano', email: 'fulano@bycoders.com', password: 'password123', password_confirmation: 'password123') }

  describe 'validations' do
    context 'when valid' do
      it 'is valid with all attributes correctly set' do
        expect(subject).to be_valid
      end

      it 'is valid with a properly formatted email' do
        subject.email = 'valid@example.com'
        expect(subject).to be_valid
      end
    end

    context 'when invalid' do
      it 'is invalid without a name' do
        subject.name = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include("can't be blank")
      end

      it 'is invalid without an email' do
        subject.email = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("can't be blank")
      end

      it 'is invalid without a password' do
        subject.password = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("can't be blank")
      end

      it 'is invalid when password confirmation does not match' do
        subject.password_confirmation = 'wrongpassword'
        expect(subject).not_to be_valid
        expect(subject.errors[:password_confirmation]).to include("doesn't match Password")
      end

      it 'is invalid with an improperly formatted email' do
        subject.email = 'invalidemail.com'
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include('is invalid')
      end
    end
  end
end

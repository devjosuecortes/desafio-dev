require 'rails_helper'
require 'cnab_validator'

RSpec.describe CnabValidator do
  describe ".valid_date?" do
    context "with valid date strings" do
      it "returns true for a valid date string" do
        result = CnabValidator.valid_date?("20231005")
        expect(result).to be_a(Date)
        expect(result.to_s).to eq("2023-10-05")
      end

      it "returns true for the earliest possible date" do
        result = CnabValidator.valid_date?("00010101")
        expect(result).to be_a(Date)
        expect(result.to_s).to eq("0001-01-01")
      end
    end

    context "with invalid date strings" do
      it "returns false for an invalid month" do
        expect(CnabValidator.valid_date?("20231305")).to be false
      end

      it "returns false for an invalid day" do
        expect(CnabValidator.valid_date?("20231032")).to be false
      end

      it "returns false for a non-numeric string" do
        expect(CnabValidator.valid_date?("abc12345")).to be false
      end

      it "returns false for an empty string" do
        expect(CnabValidator.valid_date?("")).to be false
      end
    end
  end

  describe ".valid_value?" do
    context "with valid value strings" do
      it "returns true for a valid value string" do
        expect(CnabValidator.valid_value?("0000001234")).to be true
      end

      it "returns true for the smallest valid value" do
        expect(CnabValidator.valid_value?("0000000001")).to be true
      end
    end

    context "with invalid value strings" do
      it "returns false for a string with less than 10 digits" do
        expect(CnabValidator.valid_value?("123456789")).to be false
      end

      it "returns false for a string with more than 10 digits" do
        expect(CnabValidator.valid_value?("12345678901")).to be false
      end

      it "returns false for a string containing non-numeric characters" do
        expect(CnabValidator.valid_value?("123456789a")).to be false
      end

      it "returns false for a zero value" do
        expect(CnabValidator.valid_value?("0000000000")).to be false
      end
    end
  end

  describe ".valid_cpf?" do
    context "with valid CPF strings" do
      it "returns true for a valid CPF string" do
        expect(CnabValidator.valid_cpf?("12345678901")).to be true
      end
    end

    context "with invalid CPF strings" do
      it "returns false for a string with less than 11 digits" do
        expect(CnabValidator.valid_cpf?("1234567890")).to be false
      end

      it "returns false for a string with more than 11 digits" do
        expect(CnabValidator.valid_cpf?("123456789012")).to be false
      end

      it "returns false for a string containing non-numeric characters" do
        expect(CnabValidator.valid_cpf?("1234567890a")).to be false
      end

      it "returns false for an empty string" do
        expect(CnabValidator.valid_cpf?("")).to be false
      end
    end
  end

  describe ".valid_card?" do
    context "with valid card strings" do
      it "returns true for a valid card string" do
        expect(CnabValidator.valid_card?("1234****5678")).to be true
      end
    end

    context "with invalid card strings" do
      it "returns false for a string without asterisks" do
        expect(CnabValidator.valid_card?("123456789012")).to be false
      end

      it "returns false for a string with incorrect number of asterisks" do
        expect(CnabValidator.valid_card?("1234***5678")).to be false
      end

      it "returns false for a string with incorrect length" do
        expect(CnabValidator.valid_card?("1234****567")).to be false
      end

      it "returns false for an empty string" do
        expect(CnabValidator.valid_card?("")).to be false
      end
    end
  end

  describe ".valid_time?" do
    context "with valid time strings" do
      it "returns a Time object for a valid time string" do
        result = CnabValidator.valid_time?("123456")
        expect(result).to be_a(Time)
        expect(result.strftime("%H%M%S")).to eq("123456")
      end

      it "returns a Time object for the earliest possible time" do
        result = CnabValidator.valid_time?("000000")
        expect(result).to be_a(Time)
        expect(result.strftime("%H%M%S")).to eq("000000")
      end

      it "returns a Time object for the latest possible time" do
        result = CnabValidator.valid_time?("235959")
        expect(result).to be_a(Time)
        expect(result.strftime("%H%M%S")).to eq("235959")
      end
    end

    context "with invalid time strings" do
      it "returns false for an invalid hour" do
        expect(CnabValidator.valid_time?("250000")).to be false
      end

      it "returns false for an invalid minute" do
        expect(CnabValidator.valid_time?("126000")).to be false
      end

      it "returns false for an invalid second" do
        expect(CnabValidator.valid_time?("123470")).to be false
      end

      it "returns false for a non-numeric string" do
        expect(CnabValidator.valid_time?("abc123")).to be false
      end

      it "returns false for an empty string" do
        expect(CnabValidator.valid_time?("")).to be false
      end
    end
  end
end

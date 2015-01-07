require 'test_helper'

describe Lotus::Validations do
  describe '.attribute' do
    it 'coerces attribute names to symbols' do
      assert AttributeTest.defined_validation?(:attr)
    end

    it 'ensures attribute uniqueness' do
      assert UniquenessAttributeTest.defined_validation?(:attr)
    end

    it 'collects multiple errors for a single attribute' do
      validator = MultipleValidationsTest.new(email: 'test', email_confirmation: 'x')

      validator.valid?.must_equal false

      errors = validator.errors.for(:email)
      errors.must_equal [
        Lotus::Validations::Error.new(:email, :confirmation, true, 'test'),
        Lotus::Validations::Error.new(:email, :format, /@/, 'test')
      ]
    end

    describe 'name checks' do
      it 'checks validation names' do
        -> {
          Class.new {
            include Lotus::Validations
            attribute :email, pesence: true
          }
        }.must_raise ArgumentError
      end

      it 'reports wrong names in error message' do
        begin
          Class.new {
            include Lotus::Validations
            attribute :email, pesence: true, comfirmation: true, format: /@/
          }
        rescue ArgumentError => e
          e.message.must_equal 'Unknown validation(s): pesence, comfirmation for "email" attribute'
        end
      end
    end
  end
end

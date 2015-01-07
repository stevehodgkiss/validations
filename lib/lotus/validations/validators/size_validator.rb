module Lotus
  module Validations
    module Validators
      # Validates if value's size matches the defined quantity.
      #
      # The quantity can be a Ruby Numeric:
      #
      #   * `Integer`
      #   * `Fixnum`
      #   * `Float`
      #   * `BigNum`
      #   * `BigDecimal`
      #   * `Complex`
      #   * `Rational`
      #   * Octal literals
      #   * Hex literals
      #   * `#to_int`
      #
      # The quantity can be also any object which implements `#include?`.
      #
      # If the quantity is a Numeric, the size of the value MUST be exactly the
      # same.
      #
      # If the quantity is a Range, the size of the value MUST be included.
      #
      # The value is an object which implements `#size`.
      #
      # @raise [ArgumentError] if the defined quantity isn't a Numeric or a
      #   collection
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      class SizeValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :size, options)
        end

        def validate(object, value, errors)
          return if value.nil?
          super do
            case @validator
            when Numeric, ->(v) { v.respond_to?(:to_int) }
              value.size == @validator.to_int
            when Range
              @validator.include?(value.size)
            else
              raise ArgumentError.new("Size validator must be a number or a range, it was: #{ @validator }")
            end
          end
        end
      end
    end
  end
end

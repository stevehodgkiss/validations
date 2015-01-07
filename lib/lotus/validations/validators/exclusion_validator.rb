module Lotus
  module Validations
    module Validators
      # Validates inclusion of the value in the defined collection.
      #
      # The collection is an objects which implements `#include?`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private

      # Validates exclusion of the value in the defined collection.
      #
      # The collection is an objects which implements `#include?`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      class ExclusionValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :exclusion, options)
        end

        def validate(object, value, errors)
          return if value.nil?
          super do |collection|
            !@validator.include?(value)
          end
        end
      end
    end
  end
end

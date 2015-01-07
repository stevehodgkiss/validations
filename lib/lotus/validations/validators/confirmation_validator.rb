module Lotus
  module Validations
    module Validators
      # Validates confirmation of the value with another corresponding value.
      #
      # Given a `:password` attribute, it passes if the corresponding attribute
      # `:password_confirmation` has the same value.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see Lotus::Validations::Attribute::CONFIRMATION_TEMPLATE
      #
      # @since 0.2.0
      # @api private
      class ConfirmationValidator < Attribute
        # Attribute naming convention for "confirmation" validation
        #
        # @see Lotus::Validations::Attribute#confirmation
        #
        # @since 0.2.0
        # @api private
        CONFIRMATION_TEMPLATE = '%{name}_confirmation'.freeze

        def initialize(attribute_name, options)
          super(attribute_name, :confirmation, options)
        end

        def validate(object, value, errors)
          return if value.nil?
          super do
            _attribute == _attribute(CONFIRMATION_TEMPLATE % { name: @attribute_name })
          end
        end
      end
    end
  end
end

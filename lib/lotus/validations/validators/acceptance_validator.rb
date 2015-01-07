module Lotus
  module Validations
    module Validators
      # Validates acceptance of the value.
      #
      # This passes if the value is "truthy", it fails if not.
      #
      # Truthy examples: `Object.new`, `1`, `"1"`, `true`.
      # Falsey examples: `nil`, `0`, `"0"`, `false`.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see http://www.rubydoc.info/gems/lotus-utils/Lotus/Utils/Kernel#Boolean-class_method
      #
      # @since 0.2.0
      # @api private
      class AcceptanceValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :acceptance, options)
        end

        def validate(object, value, errors)
          super { Lotus::Utils::Kernel.Boolean(value) }
        end
      end
    end
  end
end

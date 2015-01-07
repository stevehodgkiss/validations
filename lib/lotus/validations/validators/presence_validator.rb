module Lotus
  module Validations
    module Validators
      # Validates presence of the value.
      # This fails with `nil` and "blank" values.
      #
      # An object is blank if it isn't `nil`, but doesn't hold a value.
      # Empty strings and enumerables are an example.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      # @see Lotus::Validations::Attribute#nil_value?
      #
      # @since 0.2.0
      # @api private
      class PresenceValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :presence, options)
        end

        def validate(object, value, errors)
          super { !blank_value? }
        end

        private

        # Checks if the value is "blank".
        #
        # @see Lotus::Validations::BlankValueChecker
        #
        # @since 0.2.0
        # @api private
        def blank_value?
          BlankValueChecker.new(@value).blank_value?
        end
      end
    end
  end
end

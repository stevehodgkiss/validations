module Lotus
  module Validations
    module Validators
      # Validates format of the value.
      #
      # Coerces the value to a string and then check if it satisfies the defined
      # matcher.
      #
      # @see Lotus::Validations::ClassMethods#attribute
      #
      # @since 0.2.0
      # @api private
      class FormatValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :format, options)
        end

        def validate(object, value, errors)
          return if value.nil?
          super do
            value.to_s.match(@validator)
          end
        end
      end
    end
  end
end

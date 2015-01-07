module Lotus
  module Validations
    module Validators
      class InclusionValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :inclusion, options)
        end

        def validate(object, value, errors)
          return if value.nil?
          super do
            @validator.include?(value)
          end
        end
      end
    end
  end
end

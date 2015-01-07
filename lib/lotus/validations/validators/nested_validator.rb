module Lotus
  module Validations
    module Validators
      class NestedValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :nested, options)
        end

        def validate(object, value, errors)
          unless value.valid?
            errors.add_nested(@attribute_name, value.errors)
          end
        end

      end
    end
  end
end

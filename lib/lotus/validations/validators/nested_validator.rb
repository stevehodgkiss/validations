module Lotus
  module Validations
    module Validators
      class NestedValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :nested, options)
        end
      end
    end
  end
end

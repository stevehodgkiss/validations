module Lotus
  module Validations
    module Validators
      class SizeValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :size, options)
        end
      end
    end
  end
end

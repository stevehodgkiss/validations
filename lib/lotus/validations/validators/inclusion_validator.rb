module Lotus
  module Validations
    module Validators
      class InclusionValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :inclusion, options)
        end
      end
    end
  end
end

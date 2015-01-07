module Lotus
  module Validations
    module Validators
      class ExclusionValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :exclusion, options)
        end
      end
    end
  end
end

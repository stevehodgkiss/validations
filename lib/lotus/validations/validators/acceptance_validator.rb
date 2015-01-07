module Lotus
  module Validations
    module Validators
      class AcceptanceValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :acceptance, options)
        end
      end
    end
  end
end

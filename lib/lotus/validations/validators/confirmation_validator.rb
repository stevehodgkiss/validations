module Lotus
  module Validations
    module Validators
      class ConfirmationValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :confirmation, options)
        end
      end
    end
  end
end

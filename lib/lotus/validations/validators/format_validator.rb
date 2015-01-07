module Lotus
  module Validations
    module Validators
      class FormatValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :format, options)
        end
      end
    end
  end
end

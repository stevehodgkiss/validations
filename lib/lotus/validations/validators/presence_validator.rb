module Lotus
  module Validations
    module Validators
      class PresenceValidator < Attribute
        def initialize(attribute_name, options)
          super(attribute_name, :presence, options)
        end
      end
    end
  end
end

module Lotus
  module Validations
    # Validate given validations and return a set of errors
    #
    # @since x.x.x
    # @api private
    class Validator
      def initialize(object)
        @object = object
        @validation_set = object.send(:defined_validations)
        @attributes = object.send(:read_attributes)
        @errors = @object.errors
      end

      # @since x.x.x
      # @api private
      def validate
        @validation_set.each_validation do |name, attribute|
          attribute.validate(@object, @errors)
        end
      end
    end
  end
end

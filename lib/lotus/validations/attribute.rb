require 'lotus/validations/coercions'

# Quick fix for non MRI VMs that don't implement Range#size
#
# @since 0.1.0
class Range
  def size
    to_a.size
  end unless instance_methods.include?(:size)
end

module Lotus
  module Validations
    # A validable attribute
    #
    # @since 0.1.0
    # @api private
    class Attribute
      # Instantiate an attribute
      #
      # @param attributes [Hash] a set of attributes and values coming from the
      #   input
      # @param name [Symbol] the name of the attribute
      # @param value [Object,nil] the value coming from the input
      # @param validations [Hash] a set of validation rules
      #
      # @since 0.2.0
      # @api private
      def initialize(attribute_name, validation_name, options)
        @attribute_name = attribute_name
        @validation_name = validation_name
        @validator = options
      end

      # @api private
      # @since 0.2.0
      def validate(object, value, errors)
        @object = object
        @errors = errors
        @value = value

        if !yield
          errors.add(@attribute_name, Error.new(@attribute_name, @validation_name, @validator, value))
        end
      end

      # @api private
      # @since 0.2.0
      attr_reader :value

      private

      # @since 0.1.0
      # @api private
      def skip?
        @value.nil?
      end

      # Checks if the value is "blank".
      #
      # @see Lotus::Validations::BlankValueChecker
      #
      # @since 0.2.0
      # @api private
      def blank_value?
        BlankValueChecker.new(@value).blank_value?
      end

      # Reads an attribute from the validator.
      #
      # @since 0.2.0
      # @api private
      def _attribute(name = @attribute_name)
        @object.public_send(name)
      end
    end
  end
end

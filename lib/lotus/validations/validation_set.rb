module Lotus
  module Validations
    # A set of validations defined on an object
    #
    # @since x.x.x
    # @api private
    class ValidationSet
      # Allowed validations
      #
      # @since x.x.x
      # @api private
      VALIDATIONS = {
        presence: Validators::PresenceValidator,
        acceptance: Validators::AcceptanceValidator,
        format: Validators::FormatValidator,
        inclusion: Validators::InclusionValidator,
        exclusion: Validators::ExclusionValidator,
        confirmation: Validators::ConfirmationValidator,
        size: Validators::SizeValidator,
        nested: Validators::NestedValidator
      }.freeze

      # @since x.x.x
      # @api private
      def initialize
        @validations = Hash.new {|h,k| h[k] = {} }
      end

      # @since x.x.x
      # @api private
      def add(name, options)
        @validations[name.to_sym].merge!(
          validate_options!(name, options)
        )
      end

      # @since x.x.x
      # @api private
      def each(&blk)
        @validations.each(&blk)
      end

      # @since x.x.x
      # @api private
      def each_key(&blk)
        @validations.each_key(&blk)
      end

      def each_validation
        @validations.each do |attribute_name, validations|
          validations.each do |validation_name, options|
            validator = VALIDATIONS.fetch(validation_name).new(attribute_name, options)
            yield attribute_name, validator
          end
        end
      end

      private
      # Checks at the loading time if the user defined validations are recognized
      #
      # @param name [Symbol] the attribute name
      # @param options [Hash] the set of validations associated with the given attribute
      #
      # @raise [ArgumentError] if at least one of the validations are not
      #   recognized
      #
      # @since x.x.x
      # @api private
      def validate_options!(name, options)
        if (unknown = (options.keys - VALIDATIONS.keys)) && unknown.any?
          raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
        end

        # FIXME remove
        if options[:confirmation]
          add(:"#{ name }_confirmation", {})
        end

        options
      end
    end
  end
end

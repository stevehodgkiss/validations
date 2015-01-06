module Lotus
  module Validations
    # Define attributes and their validations together
    #
    # @since x.x.x
    # @api private
    module AttributeDefiner
      # Override Ruby's hook for modules.
      #
      # @param base [Class] the target action
      #
      # @since x.x.x
      # @api private
      #
      # @see http://www.ruby-doc.org/core/Module.html#method-i-included
      def self.included(base)
        base.extend ClassMethods
      end

      # @since x.x.x
      # @api private
      module ClassMethods
        # Define an attribute
        #
        # @param name [#to_sym] the name of the attribute
        # @param options [Hash] optional set of validations
        # @option options [Class] :type the Ruby type used to coerce the value
        # @option options [TrueClass,FalseClass] :acceptance requires Ruby
        #   thruthiness of the value
        # @option options [TrueClass,FalseClass] :confirmation requires the value
        #   to be confirmed twice
        # @option options [#include?] :exclusion requires the value NOT be
        #   included in the given collection
        # @option options [Regexp] :format requires value to match the given
        #   Regexp
        # @option options [#include?] :inclusion requires the value BE included in
        #   the given collection
        # @option options [TrueClass,FalseClass] :presence requires the value be
        #   included in the given collection
        # @option options [Numeric,Range] :size requires value's to be equal or
        #   included by the given validator
        #
        # @raise [ArgumentError] if an unknown or mispelled validation is given
        #
        # @since x.x.x
        #
        # @example Attributes
        #   require 'lotus/validations'
        #
        #   class Person
        #     include Lotus::Validations
        #
        #     attribute :name
        #   end
        #
        #   person = Person.new(name: 'Luca', age: 32)
        #   person.name # => "Luca"
        #   person.age  # => raises NoMethodError because `:age` wasn't defined as attribute.
        #
        # @example Standard coercions
        #   require 'lotus/validations'
        #
        #   class Person
        #     include Lotus::Validations
        #
        #     attribute :fav_number, type: Integer
        #   end
        #
        #   person = Person.new(fav_number: '23')
        #   person.valid?
        #
        #   person.fav_number # => 23
        #
        # @example Custom coercions
        #   require 'lotus/validations'
        #
        #   class FavNumber
        #     def initialize(number)
        #       @number = number
        #     end
        #   end
        #
        #   class BirthDate
        #   end
        #
        #   class Person
        #     include Lotus::Validations
        #
        #     attribute :fav_number, type: FavNumber
        #     attribute :date,       type: BirthDate
        #   end
        #
        #   person = Person.new(fav_number: '23', date: 'Oct 23, 2014')
        #   person.valid?
        #
        #   person.fav_number # => 23
        #   person.date       # => this raises an error, because BirthDate#initialize doesn't accept any arg
        #
        # @example Acceptance
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :terms_of_service, acceptance: true
        #   end
        #
        #   signup = Signup.new(terms_of_service: '1')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(terms_of_service: '')
        #   signup.valid? # => false
        #
        # @example Confirmation
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :password, confirmation: true
        #   end
        #
        #   signup = Signup.new(password: 'secret', password_confirmation: 'secret')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(password: 'secret', password_confirmation: 'x')
        #   signup.valid? # => false
        #
        # @example Exclusion
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :music, exclusion: ['pop']
        #   end
        #
        #   signup = Signup.new(music: 'rock')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(music: 'pop')
        #   signup.valid? # => false
        #
        # @example Format
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :name, format: /\A[a-zA-Z]+\z/
        #   end
        #
        #   signup = Signup.new(name: 'Luca')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(name: '23')
        #   signup.valid? # => false
        #
        # @example Inclusion
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :age, inclusion: 18..99
        #   end
        #
        #   signup = Signup.new(age: 32)
        #   signup.valid? # => true
        #
        #   signup = Signup.new(age: 17)
        #   signup.valid? # => false
        #
        # @example Presence
        #   require 'lotus/validations'
        #
        #   class Signup
        #     include Lotus::Validations
        #
        #     attribute :name, presence: true
        #   end
        #
        #   signup = Signup.new(name: 'Luca')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(name: nil)
        #   signup.valid? # => false
        #
        # @example Size
        #   require 'lotus/validations'
        #
        #   class Signup
        #     MEGABYTE = 1024 ** 2
        #     include Lotus::Validations
        #
        #     attribute :ssn,      size: 11    # exact match
        #     attribute :password, size: 8..64 # range
        #     attribute :avatar,   size  1..(5 * MEGABYTE)
        #   end
        #
        #   signup = Signup.new(password: 'a-very-long-password')
        #   signup.valid? # => true
        #
        #   signup = Signup.new(password: 'short')
        #   signup.valid? # => false

        def attribute(name, options = {}, &block)
          if block_given?
            nested_class = build_validation_class(&block)
            define_attribute(name, options.merge(type: nested_class))
          else
            define_attribute(name, options)
            validates(name, options)
          end
        end

        private

        # @since x.x.x
        # @api private
        def define_attribute(name, options)
          type = options.delete(:type)
          define_accessor(name, type)

          if options[:confirmation]
            define_accessor("#{ name }_confirmation", type)
          end
        end

        # @since x.x.x
        # @api private
        def define_accessor(name, type)
          if type
            attr_reader name
            define_coerced_writer(name, type)
          else
            attr_accessor name
          end
        end

        # @since x.x.x
        # @api private
        def define_coerced_writer(name, type)
          define_method("#{ name }=") do |value|
            instance_variable_set("@#{ name }", Lotus::Validations::Coercions.coerce(type, value))
          end
        end

        # Creates a validation class and configures it with the
        # given block.
        #
        # @since x.x.x
        # @api private
        def build_validation_class(&block)
          kls = Class.new do
            include Lotus::Validations
          end
          kls.class_eval(&block)
          kls
        end
      end

      # Create a new instance with the given attributes
      #
      # @param attributes [#to_h] an Hash like object which contains the
      #   attributes
      #
      # @since x.x.x
      #
      # @example Initialize with Hash
      #   require 'lotus/validations'
      #
      #   class Signup
      #     include Lotus::Validations
      #
      #     attribute :name
      #   end
      #
      #   signup = Signup.new(name: 'Luca')
      #
      # @example Initialize with Hash like
      #   require 'lotus/validations'
      #
      #   class Params
      #     def initialize(attributes)
      #       @attributes = Hash[*attributes]
      #     end
      #
      #     def to_h
      #       @attributes.to_h
      #     end
      #   end
      #
      #   class Signup
      #     include Lotus::Validations
      #
      #     attribute :name
      #   end
      #
      #   params = Params.new([:name, 'Luca'])
      #   signup = Signup.new(params)
      #
      #   signup.name # => "Luca"
      def initialize(attributes)
        attributes.to_h.each do |key, value|
          writer = "#{ key }="
          public_send(writer, value) if respond_to?(writer)
        end
      end
    end
  end
end

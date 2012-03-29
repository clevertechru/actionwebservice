# encoding: UTF-8
module ActionWebService
  # To send structured types across the wire, derive from ActionWebService::Struct,
  # and use +member+ to declare structure members.
  #
  # ActionWebService::Struct should be used in method signatures when you want to accept or return
  # structured types that have no Active Record model class representations, or you don't
  # want to expose your entire Active Record model to remote callers.
  #
  # === Example
  #
  #   class Person < ActionWebService::Struct
  #     member :id,         :int
  #     member :firstnames, [:string]
  #     member :lastname,   :string
  #     member :email,      :string,	:nillable => true
  #   end
  #   person = Person.new(:id => 5, :firstname => 'john', :lastname => 'doe')
  #
  # Active Record model classes are already implicitly supported in method
  # signatures.
  class Struct
    # If a Hash is given as argument to an ActionWebService::Struct constructor,
    # it can contain initial values for the structure member.
    # Values passed within the Hash that do not reflect member within the Struct will raise
    # a NoMethodError unless the optional check_hash boolean is true.
    def initialize(values={}, check_hash = false)
      if values.is_a?(Hash)
        values.map { |k,v| __send__("#{k}=", v) unless (check_hash &&  !self.respond_to?("#{k}=") ) }
      end
    end

    # The member with the given name
    def [](name)
      send(name.to_s)
    end

    # Iterates through each member
    def each_pair(&block)
      self.class.members.each do |name, type|
        yield name, self.__send__(name)
      end
    end

    class << self
      # Creates a structure member with the specified +name+ and +type+. Additional wsdl
      # schema properties may be specified in the optional hash +options+. Generates
      # accessor methods for reading and writing the member value.
      def member(name, type, options={})
        name = name.to_sym
        type = ActionWebService::SignatureTypes.canonical_signature_entry({ name => type }, 0)
        write_inheritable_hash("struct_members", name => [type, options])
        class_eval <<-END
          def #{name}; @#{name}; end
          def #{name}=(value); @#{name} = value; end
        END
      end
  
      def members # :nodoc:
        read_inheritable_attribute("struct_members") || {}
      end

      def member_type(name) # :nodoc:
        type, options = members[name.to_sym]
        type
      end
    end
  end
end

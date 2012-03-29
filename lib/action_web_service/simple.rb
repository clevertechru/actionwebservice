# encoding: UTF-8
module ActionWebService
  # To send simple types across the wire, derive from ActionWebService::Simple,
  # and use +base+ to declare the base type for it restriction and,
  # use +restriction+ to declare valid W3C restriction element for SimpleType.
  #
  # ActionWebService::Simple should be used when you want to declare valid custom simple type
  # to be used inside expects, returns and structured types
  #
  #
  # There plenty documentation available at W3C Archives
  # http://www.w3.org/TR/xmlschema-2/
  #
  # === Example
  #
  #   class Gender < ActionWebService::Simple
  #     base :string
  #     restriction :enumeration, "male|female"
  #   end
  #
  #
  class Simple

    def initialize(value)
      @value = value
    end
    
    class << self
      def base(type)
        type = type.to_s.camelize(:lower)
        write_inheritable_attribute("xml_base", type)
        class_eval <<-END
          def xml_base; "#{type}"; end
        END
      end
      
      def restriction_base
        read_inheritable_attribute("xml_base") || ""
      end
      
      def restriction(type, value)
        type = type.to_s.camelize(:lower)
        write_inheritable_hash("simple_restrictions", type => value)
      end
      
      def restrictions
        read_inheritable_attribute("simple_restrictions") || {}
      end
      
    end

  end

end

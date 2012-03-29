# encoding: UTF-8
module ActionWebService
  module ActsAsWebService
    
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Add this to your controller to include all ActionWebservice
      def acts_as_web_service
        include ActionWebService::Protocol::Discovery
        include ActionWebService::Protocol::Soap
        include ActionWebService::Protocol::XmlRpc
        include ActionWebService::Container::Direct
        include ActionWebService::Container::Delegated
        include ActionWebService::Container::ActionController
        include ActionWebService::Invocation
        include ActionWebService::Dispatcher
        include ActionWebService::Dispatcher::ActionController
        include ActionWebService::Dispatcher::ActionController::WsdlAction
        include ActionWebService::Scaffolding
      end
    end
  end
end

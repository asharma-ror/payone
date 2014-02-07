# Provides ActiveMerchant response wrapper for PAYONE requests.
module Spree::PAYONE
  module Provider
    module Payment
      class Response
        attr_accessor :redirect_url
        attr_accessor :state
        attr_accessor :response_messages
        
        def initialize(state, message, params = {}, options = {}, response_messages = {})
          @am_response = ActiveMerchant::Billing::Response.new(false, message, params, options)
          @response_messages = response_messages
          
          self.state = :failure
          if state == :success || state == true
            self.state = :success
          elsif state == :failure || state == true
            self.state = :failure
          elsif state == :redirect
            self.state = :redirect
            self.redirect_url = options[:redirect_url]
          end
        end
        
        def success?
          self.state == :success
        end
        
        def failure?
          self.state == :failure
        end
        
        def redirect?
          self.state == :redirect
        end
        
        def fraud_review?
          @am_response.fraud_review?
        end
        
        def test?
          @am_response.test?
        end
        
        def authorization
          @am_response.authorization
        end
        
        def avs_result
          @am_response.avs_result
        end
        
        def cvv_result
          @am_response.cvv_result
        end
        
        def message
          @am_response.message
        end
        
        def params
          @am_response.params
        end
        
        def test
          @am_response.test
        end
        
        def to_s
            message = @am_response.message
            
            if @response_messages.length > 0
              messages = []
              @response_messages.each do |key, value|
                messages << key.to_s + ': "' + value.to_s + '"'
              end
              message += ' (' +  messages.join(', ').to_s + ')'
            end
            
            message
        end
      end
    end
  end
end
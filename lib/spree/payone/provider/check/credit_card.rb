# Provides implementation for PAYONE creditcard check.
module Spree::PAYONE
  module Provider
    module Check
      class CreditCard < Spree::PAYONE::Provider::Base
        
        # Sets initial data.
        def initialize(options)
          super(options)
        end
        
        # Proceses check.
        def process(creditcard, options)
          Spree::PAYONE::Logger.info "Creditcardcheck process started"
          
          request = Spree::PAYONE::Proxy::Request.new
          request.creditcardcheck_request
          
          set_initial_request_parameters(request)
          set_creditcardcheck_request_parameters(request, creditcard, options)
          
          response = process_request request, options
        end
        
        # Sets credit card check parameters.
        def set_creditcardcheck_request_parameters(request, creditcard, options)
          request.yes_storecarddata
          request.cardexpiredate= credit_card_expire_date(creditcard)
          request.cardtype= credit_card_type(creditcard)
          request.cardpan= creditcard.number
          request.cardcvc2= creditcard.verification_value
          request.cardholder= creditcard.card_holder
        end
        
        # Returns credit card type.
        def credit_card_type(creditcard)
          type = Spree::PAYONE::Utils::CreditCardType.validate(creditcard.cc_type)
          if type != nil
            return type
          else
            return ''
          end
        end
        
        # Returns credit card expire date in YYMM format.
        def credit_card_expire_date(creditcard)
          creditcard.year[2,2] + ("%.2i" %  creditcard.month)
        end
      end
    end
  end
end
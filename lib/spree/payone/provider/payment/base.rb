# Provides basic communication channel between PAYONE and Spree payment process logic.
module Spree::PAYONE
  module Provider
    module Payment
      class Base < Spree::PAYONE::Provider::Base

        # Sets initial data.
        def initialize(options)
          super(options)
          @currency_code = Payone.currency_code  #'EUR'
        end

        # Sets amount parameters.
        def set_amount_request_parameters(request, amount, gateway_options)
          request.amount= amount.to_i

          # Note: if :currency_code preference is available for payment_method/gateway
          # Spree automatically adds its value to gateway_options under :currency key.
          # Of course we can set this value traditionally using payment_method/gateway preference.
          # request.currency= gateway_options[:currency]
          request.currency= @currency_code
        end

        # Sets order parameters.
        def set_order_request_parameters(request, gateway_options)
          # Order id already containts appendix responsible for payment id
          request.reference= gateway_options[:order_id].to_s
        end

        # Sets personal parameters.
        def set_personal_data_request_parameters(request, gateway_options)
          request.email= gateway_options[:email]
          request.telephonenumber= gateway_options[:billing_address][:phone] # We may send only one phone number
          # request.ip= gateway_options[:ip]
        end

        # Sets billing parameters.
        def set_billing_request_parameters(request, gateway_options)
          # Spree supports also name parameter for merged first and last name
          request.firstname = gateway_options[:billing_address][:firstname]
          request.lastname = gateway_options[:billing_address][:lastname]
          request.street= gateway_options[:billing_address][:address1]
          request.addressaddition= gateway_options[:billing_address][:address2]
          request.zip= gateway_options[:billing_address][:zip]
          request.city= gateway_options[:billing_address][:city]
          request.country= gateway_options[:billing_address][:country]
          if request.country == 'US' or request.country == 'CA'
            request.state= gateway_options[:billing_address][:state]
          end
        end

        # Sets shipping parameters.
        def set_shipping_request_parameters(request, gateway_options)
          # Spree supports also :name parameter for merged first and last name
          request.shipping_firstname= gateway_options[:shipping_address][:firstname]
          request.shipping_lastname= gateway_options[:shipping_address][:lastname]
          request.shipping_street= gateway_options[:shipping_address][:address1]
          request.shipping_zip= gateway_options[:shipping_address][:zip]
          request.shipping_city= gateway_options[:shipping_address][:city]
          request.shipping_country= gateway_options[:shipping_address][:country]
          if request.shipping_country == 'US' or request.shipping_country == 'CA'
            request.shipping_state= gateway_options[:shipping_address][:state]
          end
        end

        # Sets payment process parameters.
        def set_payment_process_parameters(request, response_code)
          request.txid= response_code
        end

        # Sets sequence request parameters.
        def set_sequence_request_parameters(request, response_code)
          request.sequencenumber= Spree::PAYONE::RequestHistory.count_overall_status_by_txid response_code
        end

        # Sets status (success/error/back) url parameters.
        def set_status_url_request_parameters(request, gateway_options)
          if gateway_options[:admin_created].to_s == 'true'
            request.successurl=
              Spree::Core::Engine.routes.url_helpers.payone_success_admin_order_payment_url(
                gateway_options[:order_id],
                gateway_options[:payment_id],
                :host => Spree::Config[:payone_engine_host],
                :token => gateway_options[:order_token],
                :action_token => success_token
              )

            request.errorurl=
              Spree::Core::Engine.routes.url_helpers.payone_error_admin_order_payment_url(
                gateway_options[:order_id],
                gateway_options[:payment_id],
                :host => Spree::Config[:payone_engine_host],
                :token => gateway_options[:order_token],
                :action_token => error_token
            )

            request.backurl=
              Spree::Core::Engine.routes.url_helpers.payone_back_admin_order_payment_url(
                gateway_options[:order_id],
                gateway_options[:payment_id],
                :host => Spree::Config[:payone_engine_host],
                :token => gateway_options[:order_token],
                :action_token => back_token
              )
          else
            request.successurl=
              Spree::Core::Engine.routes.url_helpers.payone_success_order_checkout_url(
                gateway_options[:order_id],
                :host => Spree::Config[:payone_engine_host],
                :token => gateway_options[:order_token],
                :action_token => success_token,
                :payment_id => gateway_options[:payment_id]
              )

            request.errorurl=
              Spree::Core::Engine.routes.url_helpers.payone_error_order_checkout_url(
                gateway_options[:order_id],
                :host => Spree::Config[:payone_engine_host],
                :token => gateway_options[:order_token],
                :action_token => error_token,
                :payment_id => gateway_options[:payment_id]
            )

            request.backurl=
              Spree::Core::Engine.routes.url_helpers.payone_back_order_checkout_url(
                gateway_options[:order_id],
                :host => Spree::Config[:payone_engine_host],
                :token => gateway_options[:order_token],
                :action_token => back_token,
                :payment_id => gateway_options[:payment_id]
              )
          end
        end

        # Proceses authorize action.
        # Note: Override this method. Currently not supported.
        def authorize(money, provider_source, gateway_options = {})
          Spree::PAYONE::Logger.info "Authorize process started"
          payment_payment_provider_response_not_supported 'authorize'
        end

        # Proceses gateway purchase action.
        # Note: Override this method. Currently not supported.
        def purchase(money, provider_source, gateway_options = {})
          Spree::PAYONE::Logger.info "Purchase process started"
          payment_payment_provider_response_not_supported 'purchase'
        end

        # Proceses capture action.
        # Note: Override this method. Currently not supported.
        def capture(money, response_code, gateway_options = {})
          Spree::PAYONE::Logger.info "Capture process started"
          payment_payment_provider_response_not_supported 'capture'
        end

        # Proceses void action.
        # Note: Override this method. Currently not supported.
        def void(response_code, provider_source, gateway_options = {})
          Spree::PAYONE::Logger.info "Void process started"
          payment_payment_provider_response_not_supported 'void'
        end

        # Proceses credit action.
        # Note: Override this method. Currently not supported.
        def credit(money, provider_source, response_code, gateway_options = {})
          Spree::PAYONE::Logger.info "Credit process started"
          payment_payment_provider_response_not_supported 'credit'
        end

        # Returns payment provider response object (based on ActiveMerchant response) based on data stored in PAYONE response object.
        def payment_provider_response(response)
          if response.approved?
            state = :success
            message = 'PAYONE payment provider response success'
            options = {
              :test => @test_mode,
              :authorization => response.txid
              # :avs_result N/A
              # :cvv_result N/A
            }
            response_messages = {}
          elsif response.redirect?
            state = :redirect
            message = 'PAYONE payment provider response redirect'
            options = {
              :test => @test_mode,
              :authorization => response.txid,
              :redirect_url => response.redirecturl
              # :avs_result N/A
              # :cvv_result N/A
            }
            response_messages = {}
          else
            state = :failure
            message = 'PAYONE payment provider response failure'
            options = {}
            response_messages = {
              :errormessage => response.errormessage,
              :customermessage => response.customermessage
            }
          end

          if state == :success || state == :redirect
            Spree::PAYONE::Logger.info message + ': ' + options.to_s
          else
            Spree::PAYONE::Logger.error message + ': ' + options.to_s
          end

          Spree::PAYONE::Provider::Payment::Response.new(state, message, {}, options, response_messages)
        end

        # Returns payment provider response object for not supported action.
        def payment_payment_provider_response_not_supported(action_name)
          message = 'PAYONE payment provider response failure. Action [' + action_name.to_s + '] not supported'
          Spree::PAYONE::Logger.error message
          Spree::PAYONE::Provider::Payment::Response.new(false, message, {}, {}, {})
        end

        # Returns fake successful payment provider response object.
        def payment_payment_provider_successful_response
            message = 'PAYONE payment provider response success'
            options = {
              :test => @test_mode
              # :authorization => response.txid
              # :avs_result N/A
              # :cvv_result N/A
            }
          Spree::PAYONE::Provider::Payment::Response.new(true, message, {}, options, {})
        end
      end
    end
  end
end

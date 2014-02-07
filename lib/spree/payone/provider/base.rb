# Provides basic communication channel between PAYONE and Spree logic.
module Spree::PAYONE
  module Provider
    class Base

      # Sets initial data.
      def initialize(options)
        @merchant_id = options[:merchant_id]
        @payment_portal_id = options[:payment_portal_id]
        @payment_portal_key = options[:payment_portal_key]
        @sub_account_id = options[:sub_account_id]
        @test_mode = options[:test_mode]
        @language = I18n.locale.to_s.downcase
      end

      # Sets initial parameters parameters.
      def set_initial_request_parameters(request)
        request.mid= @merchant_id
        request.portalid= @payment_portal_id
        request.key= @payment_portal_key
        request.aid= @sub_account_id
        request.language= @language

        if @test_mode
          request.test_mode
        else
          request.live_mode
        end
      end

      # Processes PAYONE request.
      def process_request(request, options = {})
        Spree::PAYONE::Logger.info "PAYONE request parameters:\n" + request.to_s
        response = request.send
        Spree::PAYONE::Logger.info "PAYONE response parameters:\n" + response.to_s
        store_request_history request, response, options
        response
      end

      # Stores request history.
      def store_request_history(request, response, options = {})
        txid = response.txid
        if txid.to_s.empty?
          txid = request.txid
        end
        request_type = request.request
        status = response.status
        overall_status = response.approved? || response.valid?
        payment_id = options[:payment_id] || nil

        RequestHistory.entry txid, request_type, status, overall_status, success_token, back_token, error_token, payment_id
      end

      # Returns random token used in success PAYONE redirect url.
      def success_token
        if @success_token == nil
          @success_token = ::SecureRandom::hex(8)
        end
        @success_token
      end

      # Returns random token used in back PAYONE redirect url.
      def back_token
        if @back_token == nil
          @back_token = ::SecureRandom::hex(8)
        end
        @back_token
      end

      # Returns random token used in error PAYONE redirect url.
      def error_token
        if @error_token == nil
          @error_token = ::SecureRandom::hex(8)
        end
        @error_token
      end

      # Returns string representation.
      def to_s
        self.class.name + " " + {:merchant_id => @merchant_id}.to_s
      end
    end
  end
end

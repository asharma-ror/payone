# Spree gateway which covers PAYONE credit card operations.
#
# Uses ::Spree::PAYONE::Provider::Payment::CreditCard for standard
# Spree gateway action implementations.
module Spree
  class Gateway::PAYONE::CreditCard < Gateway

    # Gateway preferences
    preference :merchant_id, :string
    preference :payment_portal_id, :string
    preference :payment_portal_key, :string
    preference :sub_account_id, :string
    preference :currency_code, :string, :default => 'EUR'
    preference :credit_card_types, :string, :default => 'V'
    preference :test_mode, :boolean, :default => true

    # Returns provider class responsible for Spree gateway action implementations.
    def provider_class
      ::Spree::PAYONE::Provider::Payment::CreditCard
    end

    # Returns payment source class.
    def payment_source_class
      CreditCard
    end

    # Returns profiles storage support (PAYONE on-site storage not supported).
    def payment_profiles_supported?
      true
    end

    def create_profile(payment)
      creditcard = payment.source
      method = payment.payment_method

      # Process creditcardcheck and retrieve profile id
      if creditcard.gateway_customer_profile_id.nil?
        creditCardCheck = ::Spree::PAYONE::Provider::Check::CreditCard.new(method.options)
        response = creditCardCheck.process payment.source, {}

        if response.valid_status?
          profile_id = response.pseudocardpan
          # Assign attributes one by one ("Can't mass-assign protected attributes" exception)
          # for update_attributes which is currently deprecated
          creditcard.gateway_customer_profile_id= profile_id
          creditcard.gateway_payment_profile_id= 0
          creditcard.save
        else
          raise Core::GatewayError.new(I18n.t(:payone_credit_card_check_failed))
        end
      end
    end

    # Workaround for disabling server option
    # Disable standard :server preference from gateway
    # Add :server option which depends on :test_mode setting
    alias_method :original_preferences, :preferences
    alias_method :original_options, :options

    # Returns PAYONE gateway preferences (disable :server preference).
    def preferences
      preferences_map = {}
      self.original_preferences.each do |key, value|
        if not key.to_sym == :server
          preferences_map[key] = value
        end
      end
      preferences_map
    end

    # Returns PAYONE gateway options. Internally sets :server which
    # depends on :test_mode.
    def options
      options_map = self.original_options
      options_map[:server] = 'test'
      if options_map.has_key?(:test_mode) and options_map[:test_mode] == false
        options_map[:server] = 'active'
      end
      options_map
    end

    # Redefines method_type which allows to load correct partial template
    # for gateway (does not load default _gateway.html.erb template).
    def method_type
      'payone_creditcard'
    end
  end
end

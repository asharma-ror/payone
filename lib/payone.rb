require "payone/version"
require 'payone/engine'
require 'spree_core'

# Require spree lib files
require 'logger'
require 'net/https'
require 'open-uri'

require 'spree/payone/logger'
require 'spree/payone/request_history'
require 'spree/payone/utils/credit_card_type'
require 'spree/payone/utils/store_card_data'
require 'spree/payone/provider/base'
require 'spree/payone/provider/check/credit_card'
require 'spree/payone/provider/payment/base'
require 'spree/payone/provider/payment/credit_card'
require 'spree/payone/provider/payment/response'
require 'spree/payone/proxy/parameter_container'
require 'spree/payone/proxy/response'
require 'spree/payone/proxy/request'


module Payone
  mattr_accessor :merchant_id, :payment_portal_id, :payment_portal_key, :sub_account_id, :test_mode, :currency_code, :credit_card_types

  # Default way to setup Payone. Run rails generate devise_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end

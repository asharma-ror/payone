# Stores Spree PAYONE preferences.
#
# The expectation is that this is created once and stored in
# the spree environment.
module Spree
  AppConfiguration.class_eval do

    preference :payone_merchant_id, :string
    preference :payone_payment_portal_id, :string
    preference :payone_payment_portal_key, :string
    preference :payone_sub_account_id, :string
    preference :payone_test_mode, :boolean, :default => true

    preference :payone_engine_host, :string, :default => 'localhost:3000'

    preference :payone_db_logging_enabled, :boolean, :default => true
    preference :payone_file_logging_enabled, :boolean, :default => true
    preference :payone_logger_filepath, :string, :default => 'log/spree_payone.log'
  end
end

module Payone
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :merchant_id, :type => :string
      class_option :payment_portal_id, :type => :string
      class_option :payment_portal_key, :type => :string
      class_option :sub_account_id, :type => :string
      class_option :test_mode, :type => :boolean
      class_option :currency_code, :type => :string
      class_option :credit_card_types, :type => :string

      source_root File.expand_path("../../../templates", __FILE__)

      def copy_initializer
        template "payone_config.rb", "config/initializers/payone_config.rb"
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=payone'
      end

      def run_migrations
         res = ask "Would you like to run the migrations now? [Y/n]"
         if res == "" || res.downcase == "y"
           run 'bundle exec rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end
    end
  end
end

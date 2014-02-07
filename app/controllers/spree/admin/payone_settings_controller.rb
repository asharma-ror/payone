module Spree
  module Admin
    class PayoneSettingsController < BaseController
      def init_preferences
        @redirect_url_preferences = {
          :payone_engine_host => {}
        }

        @logging_preferences = {
          :payone_db_logging_enabled => {},
          :payone_file_logging_enabled => {}
        }
      end

      def show
        init_preferences
      end

      def edit
        init_preferences
      end

      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end

        redirect_to admin_payone_settings_path
      end

      def dismiss_alert
        if request.xhr? and params[:alert_id]
          dismissed = Spree::Config[:dismissed_spree_alerts] || ''
          Spree::Config.set :dismissed_spree_alerts => dismissed.split(',').push(params[:alert_id]).join(',')
          filter_dismissed_alerts
          render :nothing => true
        end
      end
    end
  end
end

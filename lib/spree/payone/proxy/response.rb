# Representation of raw PAYONE response.
module Spree::PAYONE
  module Proxy
    class Response < ParameterContainer

      # Respose status
      parameter_accessor :status
      # Error number
      parameter_accessor :errorcode
      # Error message
      parameter_accessor :errormessage
      # Error message for the end customer (Language selection occurs via the end customer's language, "language")
      parameter_accessor :customermessage
      # Payment process ID (PAYONE)
      parameter_accessor :txid
      # Debtor ID (PAYONE)
      parameter_accessor :userid
      # Redirect URL
      parameter_accessor :redirecturl

      # Specific values for :status parameter
      parameter_value_accessor :approved_status, :status, 'APPROVED'
      parameter_value_accessor :error_status, :status, 'ERROR'
      parameter_value_accessor :redirect_status, :status, 'REDIRECT'
      parameter_value_accessor :valid_status, :status, 'VALID'
      parameter_value_accessor :invalid_status, :status, 'INVALID'

      # Sets initial data.
      def initialize response_body = ''
        super()
        self.response_body= response_body.to_s
      end

      # Sets and automatically parses reponse body content.
      def response_body= value
        @response_body = value
        self.parse_reponse_body
      end

      # Returns response body.
      def response_body
        @response_body
      end

      # Checks if response is in approved state.
      def approved?
        approved_status?
      end

      # Checks if response is in redirect state.
      def redirect?
        redirect_status?
      end

      # Checks if response is in error state.
      def error?
        error_status?
      end

      # Checks if response is in valid state.
      def valid?
        valid_status?
      end

      # Checks if response is in invalid state.
      def invalid?
        invalid_status?
      end

      # Parses response body content and stores it in parameters.
      def parse_reponse_body
        self.delete_parameters

        @response_body.to_s.scan(/^([^=]*)=(.*)$/).each do |key_value|
          if key_value.kind_of? Array and key_value.length > 1
            self.dynamic_parameter_define key_value[0]
            self.send key_value[0] + "=", key_value[1]
          end
        end
      end

      # Saves value for specified key (in key=value format).
      def scan_for_value(searched_key, str)
          scan = str.scan(/^#{Regexp.escape(searched_key)}=(.*)$/)
          if not scan.empty? and not scan[0].empty?
            self.dynamic_parameter_define searched_key
            self.send searched_key + "=", scan[0][0]
          end
      end

      # Define parameters accessors dynamically.
      def dynamic_parameter_define parameter
        if not self.respond_to?(parameter)
          parameter = "customermessage" if parameter == "\ncustomermessage"
          self.class.parameter_accessor parameter.to_sym
        end
      end

      # Gets values of parameters which are not defined.
      def method_missing(method_name, *args)
        method_name = method_name.to_s
        scan_for_value(method_name, @response_body)
        self.respond_to?(method_name) ? self.send(method_name) : nil
      end
    end
  end
end

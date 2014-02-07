# Representation of raw PAYONE request.
module Spree::PAYONE
  module Proxy
    class Request < ParameterContainer

      # PAYONE FinanceGate Server API Url
      @@API_URL = 'https://api.pay1.de/post-gateway/'

      # Defines parameters that should be hidden (i.e. not visible when logging)
      @@HIDDEN_PARAMETERS = [:cardpan, :cardcvc2, :bankaccount, :bankcode]

      # Merchant account ID
      parameter_accessor :mid
      # Payment portal ID
      parameter_accessor :portalid
      # Payment portal key as MD5 value
      parameter_accessor :key, false, true
      # Test: Test mode, Live: Live mode
      # Note: we will ony create getter method while we need md5 conversion for setter
      parameter_accessor :mode
      # Queries: preauthorization, authorization, capture, refund, ...
      parameter_accessor :request
      # ISO-8859-1 (default), UTF-8
      parameter_accessor :encoding

      # Sub account ID
      parameter_accessor :aid

      # Payment process ID (PAYONE)
      parameter_accessor :txid

      # Clearing type
      # elv: Debit payment, cc: Credit card, vor: Prepayment/Cash In Advance, rec: Invoice
      # cod: Cash on delivery, sb: Online Bank Transfer, wlt: e-wallet
      parameter_accessor :clearingtype
      # Merchant reference number for the payment process (permitted symbols: 0-9, a-z, A-Z, .,-,_,/)
      parameter_accessor :reference
      # Total amount (in smallest currency unit! e.g. cent)
      parameter_accessor :amount
      # Currency (ISO 4217)
      parameter_accessor :currency

      # URL "payment successful" (only if not provided in the PMI)
      parameter_accessor :successurl
      # URL "faulty payment" (only if not provided in the PMI)
      parameter_accessor :errorurl
      # URL "Back" or "Cancel" (only if not provided in the PMI)
      parameter_accessor :backurl

      # Merchant's customer ID (permitted symbols: 0-9, a-z, A-Z, .,-,_,/)
      parameter_accessor :customerid
      # First name
      parameter_accessor :firstname
      # Surname
      parameter_accessor :lastname

      # Email address
      parameter_accessor :email
      # Telephone numner
      parameter_accessor :telephonenumber
      # Customer's IP address (123.123.123.123)
      parameter_accessor :ip

      # Street number and name
      parameter_accessor :street
      # Address line 2 (e.g. "7th floor", "c/o Maier")
      parameter_accessor :addressaddition
      # Postcode
      parameter_accessor :zip
      # City
      parameter_accessor :city
      # Country (ISO 3166)
      parameter_accessor :country
      # State (ISO 3166 subdivisions) (only if country=US or CA)
      parameter_accessor :state

      # First name
      parameter_accessor :shipping_firstname
      # Surname
      parameter_accessor :shipping_lastname
      # Street number and name
      parameter_accessor :shipping_street
      # Postcode
      parameter_accessor :shipping_zip
      # City
      parameter_accessor :shipping_city
      # Country (ISO 3166)
      parameter_accessor :shipping_country
      # State (ISO 3166 subdivisions) (only if country=US or CA)
      parameter_accessor :shipping_state

      # Address check type
      # BA: Addresscheck Basic, PE: Addresscheck Person, NO: Do not carry out address check
      parameter_accessor :addresschecktype

      # Consumer score type
      # IH: Infoscore (hard criteria), IA: Infoscore (all criteria), IB: Infoscore (all criteria + bonuses score)
      parameter_accessor :consumerscoretype

      # Card number
      parameter_accessor :cardpan
      # Card type
      # V: Visa, M: MasterCard, A: Amex, D: Diners, J: JCB,
      # O: Maestro International, C: Discover, B: Carte Bleue
      parameter_accessor :cardtype
      # Expiry date YYMM
      parameter_accessor :cardexpiredate
      # Credit verification number (CVC)
      parameter_accessor :cardcvc2
      # Card holder
      parameter_accessor :cardholder
      # Pseudo card number
      parameter_accessor :pseudocardpan
      # Store card data
      # no: Card data is not stored
      # yes: Card data is stored, a pseudo card number is returned
      parameter_accessor :storecarddata

      # Online bank transfer type
      # PNT: instant money transfer (DE,AT,CH), GPY: giropay (DE)
      # EPS: eps – online transfer (AT), PFF: PostFinance E-Finance (CH)
      # PFC: PostFinance Card (CH), IDL: iDeal (NL)
      parameter_accessor :onlinebanktransfertype
      # Account type/country (DE, AT, CH, NL)
      parameter_accessor :bankcountry
      # Account number (giropay & instant money transfer only)
      parameter_accessor :bankaccount
      # Sort code (giropay & instant money transfer only)
      parameter_accessor :bankcode
      # Bank Group (eps & iDeal only)
      parameter_accessor :bankgrouptype

      # Account holder
      parameter_accessor :bankaccountholder

      # Wallet provider
      # PPE: PayPal Express
      parameter_accessor :wallettype

      # Shipping company
      # DHL: DHL, Germany
      # BRT: Bartolini, Italy
      parameter_accessor :shippingprovider

      # Language indicator (ISO 639)
      # Note: this parameter is used to set language of messages returned by PAYONE PMI
      parameter_accessor :language

      # Sequence number for this transaction within the payment process (1..n)
      # e.g. authorisation: 0, debit: 1 e.g. preauthorisation: 0, capture: 1, debit: 2
      parameter_accessor :sequencenumber

      # Specific values for :request parameter
      parameter_value_accessor :preauthorization_request, :request, 'preauthorization'
      parameter_value_accessor :authorization_request, :request, 'authorization'
      parameter_value_accessor :capture_request, :request, 'capture'
      parameter_value_accessor :refund_request, :request, 'refund'
      parameter_value_accessor :debit_request, :request, 'debit'
      parameter_value_accessor :addresscheck_request, :request, 'addresscheck'
      parameter_value_accessor :consumerscore_request, :request, 'consumerscore'
      parameter_value_accessor :creditcardcheck_request, :request, 'creditcardcheck'

      # Specific values for :mode parameter
      parameter_value_accessor :test_mode, :mode, 'test'
      parameter_value_accessor :live_mode, :mode, 'live'

      # Specific values for :encoding parameter
      parameter_value_accessor :iso88591_encoding, :encoding, 'ISO-8859-1'
      parameter_value_accessor :utf8_encoding, :encoding, 'UTF-8'

      # Specific values for :clearingtype parameter
      parameter_value_accessor :credit_card_clearingtype, :clearingtype, 'cc'
      parameter_value_accessor :online_bank_transfer_clearingtype, :clearingtype, 'sb'
      parameter_value_accessor :debit_payment_clearingtype, :clearingtype, 'elv'
      parameter_value_accessor :e_wallet_clearingtype, :clearingtype, 'wlt'
      parameter_value_accessor :cash_on_delivery_clearingtype, :clearingtype, 'cod'
      parameter_value_accessor :cash_in_advance_clearingtype, :clearingtype, 'vor'
      parameter_value_accessor :invoice_clearingtype, :clearingtype, 'rec'

      # Specific values for :cardtype parameter
      parameter_value_accessor :visa_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::VISA
      parameter_value_accessor :mastercard_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::MASTERCARD
      parameter_value_accessor :amex_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::AMEX
      parameter_value_accessor :diners_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::DINERS
      parameter_value_accessor :jbc_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::JBC
      parameter_value_accessor :maestro_international_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::MAESTRO_INTERNATIONAL
      parameter_value_accessor :discover_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::DISCOVER
      parameter_value_accessor :carte_bleue_cardtype, :cardtype, ::Spree::PAYONE::Utils::CreditCardType::CARTE_BLEUE

      # Specific values for :addresschecktype parameter
      #parameter_value_accessor :basic_addresschecktype, :addresschecktype, ::Spree::PAYONE::Utils::AddressCheckType::BASIC
      #parameter_value_accessor :person_addresschecktype, :addresschecktype, ::Spree::PAYONE::Utils::AddressCheckType::PERSON
      #parameter_value_accessor :no_addresschecktype, :addresschecktype, ::Spree::PAYONE::Utils::AddressCheckType::NO

      # Specific values for :consumerscoretype parameter
      #parameter_value_accessor :ih_consumerscoretype, :consumerscoretype, ::Spree::PAYONE::Utils::ConsumerScoreType::IH
      #parameter_value_accessor :ia_consumerscoretype, :consumerscoretype, ::Spree::PAYONE::Utils::ConsumerScoreType::IA
      #parameter_value_accessor :ib_consumerscoretype, :consumerscoretype, ::Spree::PAYONE::Utils::ConsumerScoreType::IB

      # Specific values for :storecarddata parameter
      parameter_value_accessor :yes_storecarddata, :storecarddata, ::Spree::PAYONE::Utils::StoreCardData::YES
      parameter_value_accessor :no_storecarddata, :storecarddata, ::Spree::PAYONE::Utils::StoreCardData::NO

      # Sets initial data.
      def initialize
        super()
        self.test_mode
      end

      # Returns PAYONE FinanceGate Server API Url.
      def api_url
        @@API_URL
      end

      # Sets key value or md5 value.
      def key=(value, md5_encode = true)
        if md5_encode && value
          self.add_parameter(:key, Digest::MD5.hexdigest(value))
        else
          self.add_parameter(:key, value)
        end
      end

      # Send the PAYONE request.
      def send
        post_params = {}
        self.parameters.each { |key, value|
          if value.is_a? Array
            i = 0
            value.each { |value_value|
              post_params[key.to_s + '[' + i.to_s + ']'] = value_value.to_s
              i += 1
            }
          elsif value.is_a? Hash
            value.each { |value_key, value_value|
              post_params[key.to_s + '[' + value_key.to_s + ']'] = value_value.to_s
            }
          else
            post_params[key.to_s] = value.to_s
          end
        }

        url = URI.parse(@@API_URL)
        http_request = Net::HTTP::Post.new(url.path)
        http_request.form_data = post_params
        http_request.basic_auth url.user, url.password if url.user

        response = Spree::PAYONE::Proxy::Response.new
        connection = Net::HTTP.new(url.host, url.port)
        load_ca_file connection
        connection.use_ssl = true
        connection.start { |http|
          http_response = http.request(http_request)
          response.response_body= http_response.body
        }

        response
      end

      def to_s
        result = ''
        @parameters.each do |key, value|
          if @@HIDDEN_PARAMETERS.include? key
            value = value.to_s.gsub(/./, 'x')
          end
          result += "#{key}: \"#{value}\"\n"
        end
        result.strip
      end

      # Sets Certificate Authority file used by PAYONE.
      #
      # The same functionality may be achived globally using below code:
      #
      #   module Net
      #     class HTTP
      #       alias_method :original_use_ssl=, :use_ssl=
      #       def use_ssl=(flag)
      #         self.ca_file = Dir.pwd + '/ThawtePremiumServerCA.crt'
      #         self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      #         self.original_use_ssl = flag
      #       end
      #     end
      #   end
      def load_ca_file connection
        connection.ca_file = File.dirname(__FILE__) + '/ThawtePremiumServerCA.crt'
      end
    end
  end
end

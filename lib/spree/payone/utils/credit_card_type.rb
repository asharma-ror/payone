# Container for credit card type values.
module Spree::PAYONE
  module Utils
    class CreditCardType
      # Credit card type values
      VISA = 'V'
      MASTERCARD = 'M'
      AMEX = 'A'
      DINERS = 'D'
      JBC = 'J'
      MAESTRO_INTERNATIONAL = 'O'
      DISCOVER = 'C'
      CARTE_BLEUE = 'B'
      
      # Credit card type symbol values
      VISA_SYMBOL = :credit_card_type_visa
      MASTERCARD_SYMBOL = :credit_card_type_mastercard
      AMEX_SYMBOL = :credit_card_type_amex
      DINERS_SYMBOL = :credit_card_type_diners
      JBC_SYMBOL = :credit_card_type_jbc
      MAESTRO_INTERNATIONAL_SYMBOL = :credit_card_type_maestro_international
      DISCOVER_SYMBOL = :credit_card_type_discover
      CARTE_BLEUE_SYMBOL = :credit_card_type_carte_bleue
      
      # Validates credit card type and returns PAYONE specific code.
      def self.validate(type)
        type = type.to_s.downcase
        if type =~ /^visa$/ or type =~ /^v$/
          return self::VISA
        elsif type =~ /^mastercard$/ or type =~ /^master card$/ or type =~ /^m$/
          return self::MASTERCARD
        elsif type =~ /^amex$/ or type =~ /^a$/
          return self::AMEX
        elsif type =~ /^diners$/ or type =~ /^d$/
          return self::DINERS
        elsif type =~ /^jbc$/ or type =~ /^j$/
          return self::JBC
        elsif type =~ /^maestrointernational$/ or type =~ /^maestro international$/ or type =~ /^o$/
          return self::MAESTRO_INTERNATIONAL
        elsif type =~ /^discover$/ or type =~ /^c$/
          return self::DISCOVER
        elsif type =~ /^cartebleue$/ or type =~ /^carte bleue$/ or type =~ /^b$/
          return self::CARTE_BLEUE
        else
          nil
        end
      end
      
      # Validates credit card type and returns symbol.
      def self.validate_symbol(type)
        case self.validate(type)
          when self::VISA
            return self::VISA_SYMBOL
          when self::MASTERCARD
            return self::MASTERCARD_SYMBOL
          when self::AMEX
            return self::AMEX_SYMBOL
          when self::DINERS
            return self::DINERS_SYMBOL
          when self::JBC
            return self::JBC_SYMBOL
          when self::MAESTRO_INTERNATIONAL
            return self::MAESTRO_INTERNATIONAL_SYMBOL
          when self::DISCOVER
            return self::DISCOVER_SYMBOL
          when self::CARTE_BLEUE
            return self::CARTE_BLEUE_SYMBOL
          else
            return nil
        end
      end
      
      # Returns all values array.
      def self.list()
        [self::VISA, self::MASTERCARD, self::AMEX, self::DINERS, self::JBC,
         self::MAESTRO_INTERNATIONAL, self::DISCOVER, self::CARTE_BLEUE]
      end
    end
  end
end
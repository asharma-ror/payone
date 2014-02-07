# Container for store card data values.
module Spree::PAYONE
  module Utils
    class StoreCardData
      # Store card data values
      YES = 'yes'
      NO = 'no'
      
      # Store card data symbol values
      YES_SYMBOL = :store_card_data_yes
      NO_SYMBOL = :store_card_data_no
      
      # Validates store card data and returns PAYONE specific code.
      def self.validate(type)
        type = type.to_s.downcase
        if type =~ /^yes$/ or type =~ /^y$/ or type =~ /^true$/ or type =~ /^t$/
          return self::YES
        elsif type =~ /^no$/ or type =~ /^n$/ or type =~ /^false$/ or type =~ /^f$/
          return self::NO
        else
          nil
        end
      end
      
      # Validates store card data and returns symbol.
      def self.validate_symbol(type)
        case self.validate(type)
          when self::YES
            return self::YES_SYMBOL
          when self::NO
            return self::NO_SYMBOL
          else
            return nil
        end
      end
      
      # Returns all values array.
      def self.list()
        [self::YES, self::NO]
      end
    end
  end
end
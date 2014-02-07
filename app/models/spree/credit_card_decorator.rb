module Spree
  CreditCard.class_eval do
    #attr_accessible :cc_type, :card_holder
    
    # Returns card holder.
    def card_holder
      # Internally use first and last name fields to store card holder (workaround)
      self.first_name.to_s.empty? ?
        self.last_name.to_s :
        (self.last_name.to_s.empty? ?
          self.first_name.to_s : self.first_name.to_s + ' ' + self.last_name.to_s)
    end
    
    # Sets card holder.
    def card_holder= value
      # Internally use first and last name fields to store card holder (workaround)
      values = value.to_s.split(' ')
      if values.size > 1
        self.first_name= values[0]
        self.last_name= values[1]
      elsif values.size == 1
        self.last_name= values[0]
      end
    end
    
    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      if payment.payment_method.is_a?(Spree::Gateway::PAYONE::CreditCard)
        return payment.state != 'void' && payment.state != 'completed' && payment.state != 'failed' && payment.state != 'processing'
      end
      return payment.state != 'void'
    end
    
    # Indicates whether its possible to credit the payment.
    def can_credit?(payment)
      return false if payment.payment_method.is_a?(Spree::Gateway::PAYONE::CreditCard)
      return false unless payment.state == 'completed'
      return false unless payment.order.payment_state == 'credit_owed'
      payment.credit_allowed > 0
    end
  end
end

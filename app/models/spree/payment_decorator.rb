module Spree
  Payment.class_eval do
    attr_accessor :admin_created

    def admin_created?
      !!admin_created
    end

    state_machine :initial => :checkout do
      # With card payments, happens before purchase or authorization happens
      event :started_processing do
        transition :from => [:checkout, :pending, :completed, :processing], :to => :processing
      end
      # When processing during checkout fails
      event :failure do
        transition :from => [:processing, :pending], :to => :failed
      end
      # With card payments this represents authorizing the payment
      event :pend do
        transition :from => [:checkout, :processing], :to => :pending
      end
      # With card payments this represents completing a purchase or capture transaction
      event :complete do
        transition :from => [:processing, :pending, :checkout], :to => :completed
      end
      event :void do
        transition :from => [:pending, :completed, :checkout], :to => :void
      end
    end

    def handle_response(response, success_state, failure_state, redirect_state = :started_processing)
      record_response(response)

      if response.success?
        self.response_code = response.authorization
        self.avs_response = response.avs_result['code']
        self.send("#{success_state}!")
      elsif response.is_a?(::Spree::PAYONE::Provider::Payment::Response) && response.redirect?
        self.response_code = response.authorization
        self.avs_response = response.avs_result['code']
        self.redirect_url = response.redirect_url
        self.send("#{redirect_state}!")
      else
        self.send("#{failure_state}!")
        gateway_error(response)
      end
    end

    private

    alias_method :original_gateway_options, :gateway_options

    def gateway_options
      options = original_gateway_options
      options.merge!({ :order_token => order.token,
                       :payment_id => self.id,
                       :admin_created => self.admin_created })
      options.merge!({ :billing_address =>
                          options[:billing_address].merge!({
                            :firstname => order.bill_address.firstname,
                            :lastname => order.bill_address.lastname })})
      options.merge!({ :shipping_address =>
                          options[:shipping_address].merge!({
                            :firstname => order.ship_address.firstname,
                            :lastname => order.ship_address.lastname })})
    end
  end
end

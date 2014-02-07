# Provides PAYONE LOG model. It is used to store logs.
module Spree
  class PayoneLog < ActiveRecord::Base
    # we must run logger within new connection to avoid changes to be rollbacked
    # for details see: state_machine documentation
    establish_connection Rails.env.to_sym

    #attr_accessible :level, :message
  end
end

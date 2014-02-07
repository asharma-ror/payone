# Provides PAYONE request history model. It is used to store request history.
module Spree
  class PayoneRequestHistoryEntry < ActiveRecord::Base
    # we must run logger within new connection to avoid changes to be rollbacked
    # for details see: state_machine documentation
    establish_connection Rails.env.to_sym

    #attr_accessible :txid, :request_type, :status, :overall_status
  end
end

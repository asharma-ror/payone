class CreatePayoneRequestHistoryEntries < ActiveRecord::Migration
  def change
    create_table :spree_payone_request_history_entries do |t|
      t.string :txid, :request_type, :status, :success_token, :back_token, :error_token
      t.boolean :overall_status
      t.integer :payment_id, :default => nil, :null => true
      
      t.timestamps
    end
  end
end

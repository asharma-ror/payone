class CreatePayoneLogs < ActiveRecord::Migration
  def change
    create_table :spree_payone_logs do |t|
      t.string :level
      t.text :message
      
      t.timestamps
    end
  end
end

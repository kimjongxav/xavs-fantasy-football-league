class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :value
      add_foreign_key :bids, :teams
      add_foreign_key :bids, :players

      t.timestamps
    end
  end
end

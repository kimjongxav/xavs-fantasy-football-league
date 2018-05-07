class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :value
      t.integer :player_id
      t.integer :user_id

      add_reference :bids, :player, foreign_key: true
      add_reference :bids, :user, foreign_key: true

      t.timestamps
    end
  end
end

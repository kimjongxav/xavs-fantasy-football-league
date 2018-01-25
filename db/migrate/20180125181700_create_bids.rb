class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :value
      t.references :team, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end

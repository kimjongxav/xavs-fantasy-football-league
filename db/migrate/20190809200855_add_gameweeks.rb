class AddGameweeks < ActiveRecord::Migration[5.1]
  def change
    create_table :gameweeks do |t|
      t.integer :deadline_time_epoch
    end
  end
end

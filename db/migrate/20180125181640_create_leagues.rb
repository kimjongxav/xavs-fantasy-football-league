class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.string :season
      t.string :name

      t.timestamps
    end
  end
end

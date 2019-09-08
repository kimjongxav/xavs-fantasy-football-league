class AddPictureToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :picture, :string
  end
end

class AddInitialsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :initials, :string
  end
end

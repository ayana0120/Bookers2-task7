class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :postcode, :string
    add_column :users, :prefecture_code, :integer
    add_column :users, :city, :string
    add_column :users, :street, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end

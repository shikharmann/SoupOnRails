class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      # Name of the users
      t.string :name, null: false
      t.timestamps
    end
  end
end
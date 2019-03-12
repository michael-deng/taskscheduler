class CreateDependencies < ActiveRecord::Migration[5.2]
  def change
    create_table :dependencies do |t|
      t.integer :parent
      t.integer :child

      t.timestamps
    end
  end
end

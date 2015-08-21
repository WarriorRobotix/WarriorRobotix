class CreateGlobalVars < ActiveRecord::Migration
  def change
    create_table :global_vars do |t|
      t.string :name, null: false, index: true
      t.integer :data_type, default: 0

      t.string :string_value
      t.integer :integer_value
    end
  end
end

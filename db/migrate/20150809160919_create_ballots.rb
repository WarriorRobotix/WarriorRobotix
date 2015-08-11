class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.belongs_to :member
      t.belongs_to :option, index: true

      t.timestamps null: false
    end
  end
end

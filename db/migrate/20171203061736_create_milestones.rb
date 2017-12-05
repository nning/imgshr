class CreateMilestones < ActiveRecord::Migration[5.0]
  def change
    create_table :milestones do |t|
      t.belongs_to :gallery, foreign_key: true, index: true
      t.datetime :time, null: false
      t.string :description, null: false
      t.boolean :show_on_pictures, default: false

      t.timestamps
    end
  end
end

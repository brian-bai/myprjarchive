class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.string :company
      t.string :position
      t.date :startdate
      t.date :enddate
      t.text :details
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end

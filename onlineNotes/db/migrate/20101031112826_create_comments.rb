class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.integer :user_id
      t.references :note

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

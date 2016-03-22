class AddUsernameToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :writer, :string
  end

  def self.down
    remove_column :notes, :writer
  end
end

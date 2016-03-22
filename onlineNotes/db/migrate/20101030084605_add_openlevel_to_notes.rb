class AddOpenlevelToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :openlevel, :integer, :default => 1
  end

  def self.down
    remove_column :notes, :openlevel
  end
end

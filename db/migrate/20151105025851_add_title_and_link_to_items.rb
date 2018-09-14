class AddTitleAndLinkToItems < ActiveRecord::Migration
  def change
    add_column :items, :title, :string
    add_column :items, :link, :string
  end
end

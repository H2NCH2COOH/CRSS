class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uname
    end

    create_table :items do |t|
      t.belongs_to :user, index: true
      t.datetime :date
      t.string :data
    end
  end
end

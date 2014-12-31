class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :url
      t.text :params
      t.string :response
      t.string :IP

      t.timestamps
    end
  end
end

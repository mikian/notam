class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :identifier
      t.string :text
      t.integer :type
      t.integer :reference_id
      t.string :source
      t.string :fields

      t.timestamps null: false
    end
  end
end

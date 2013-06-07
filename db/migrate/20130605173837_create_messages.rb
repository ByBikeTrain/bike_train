class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :group_id
      t.boolean :read
      t.timestamps
    end
  end
end

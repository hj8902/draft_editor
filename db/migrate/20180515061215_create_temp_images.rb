class CreateTempImages < ActiveRecord::Migration[5.2]
  def change
    create_table :temp_images do |t|

      t.timestamps
    end
  end
end

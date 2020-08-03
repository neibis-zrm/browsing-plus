class CreateTrends < ActiveRecord::Migration[6.0]
  def change
    create_table :trends do |t|

      t.timestamps
    end
  end
end

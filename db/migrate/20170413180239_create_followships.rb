class CreateFollowships < ActiveRecord::Migration[5.0]
  def change
    create_table :followships do |t|

      t.timestamps
    end
  end
end

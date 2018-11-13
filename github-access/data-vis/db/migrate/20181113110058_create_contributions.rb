class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.belongs_to :repo, index: true
      t.belongs_to :user, index: true
      t.integer :commits
      t.integer :issues_closed

      t.timestamps
    end
  end
end

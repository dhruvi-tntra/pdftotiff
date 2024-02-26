class CreatePlanPages < ActiveRecord::Migration[7.1]
  def change
    create_table :plan_pages do |t|
      t.integer :page_no

      t.timestamps
    end
  end
end

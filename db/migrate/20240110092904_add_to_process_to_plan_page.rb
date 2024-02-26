class AddToProcessToPlanPage < ActiveRecord::Migration[7.1]
  def change
    add_column :plan_pages, :to_process, :boolean, default: false
  end
end

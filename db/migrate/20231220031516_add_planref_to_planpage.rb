class AddPlanrefToPlanpage < ActiveRecord::Migration[7.1]
  def change
    add_reference :plan_pages, :plan, foreign_key: true
  end
end

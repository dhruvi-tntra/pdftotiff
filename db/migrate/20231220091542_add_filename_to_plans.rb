class AddFilenameToPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :plans, :pdffilename, :string
  end
end

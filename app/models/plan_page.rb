class PlanPage < ApplicationRecord
  require "vips"
  belongs_to :plan
  has_one_attached :tiff_file
  # has_one_attached :tiff_file do |attachable|
  #   attachable.variant :pdf, format: :pdf, loader: { page: nil } # page: nil is needed to convert all pages
  # end

  def show_image
    im = Vips::Image.new_from_buffer(tiff_file_blob.download, 'test')
    im = im.resize(2.0) 
    # im = im.embed 1, 1, 30, 30

    
    # im = Vips::Image.new_from_file filename
    # im = im.embed 100, 100, 3000, 3000, extend: :mirror
    # im
  end
end

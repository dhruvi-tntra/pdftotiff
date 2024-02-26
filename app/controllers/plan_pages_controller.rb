class PlanPagesController < ApplicationController
  require 'base64'
  def index
    @plan_pages = PlanPage.where(plan_id: params[:format])
    @image_data = { image_url: @plan_pages.first.tiff_file_blob.attachments.first.url }
  end

  def new
  end

  def create
  end
  
  def show
    ActiveStorage::Current.url_options = { host: 'localhost:3000' }
    plan_pages = PlanPage.where(plan_id: params[:id])
    
    # @image_urls = ["https://stock.adobe.com/in/search?k=hello&asset_id=209651427", "https://images.unsplash.com/photo-1516295615676-7ae4303c1c63"]
    # @image_urls = plan_pages.map { |page| "#{url_for(page.tiff_file.variant(:pdf))}" }
    # @image_urls = plan_pages.map { |page| rails_blob_url(page.tiff_file_blob) }

    @encoded_images = []

    plan_pages.each do |page|
      vips_image = page.show_image
      jpeg_image_data = vips_image.jpegsave_buffer
      encoded_image_data = Base64.strict_encode64(jpeg_image_data)
    
      @encoded_images << encoded_image_data
    end

    # vips_image = plan_pages.first.show_image
    # quality = 90 # set the desired quality value

    # vips_image = plan_pages.first.show_image
    # @jpeg_image_data = vips_image.jpegsave_buffer
    # @encoded_image_data = Base64.strict_encode64(@jpeg_image_data)

    # image_data = { image_url: plan_pages.first.tiff_file_blob.attachments.first.url }
    respond_to do |format|
      format.html
      format.js
    end
  end
  def selected_images
    params[:selectedIndices].each do |p|
      plan_page = PlanPage.find_by(plan_id: params['planId'].to_i, page_no: p.to_i)
      plan_page.to_process = true
      plan_page.save
    end
  
    respond_to do |format|
      format.js
      format.html { redirect_to root_path, notice: 'Data sent for processing.' }
    end
  end
end

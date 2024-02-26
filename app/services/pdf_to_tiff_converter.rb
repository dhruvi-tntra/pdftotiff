# require 'mini_magick'
require 'vips'

class PdfToTiffConverter
  def initialize(pdf_path, plan)
		@plan = plan
    @pdf_path = pdf_path
    @output_path = Rails.root.join('tmp', 'pdf_to_tiff_output')
    FileUtils.mkdir_p(@output_path)
  end

  def convert
    # create_plan_pages
    plan_convert_to_png
    convert_png_to_tiff
    # cleanup_temp_files
  end

  private
  def create_plan_pages
    PlanPage.new
  end 

  def plan_convert_to_png
    plan_pages = []
    # Assuming @pdf_path is the path to your PDF file
    # Assuming @output_path is the directory where you want to save PNG files
  
    # Get the total number of pages in the PDF
    total_pages = `pdfinfo #{@pdf_path} | grep "Pages"`.split(":").last.to_i
  
    # Iterate through each page and generate PNG files
    (1..total_pages).each do |page_number|
			plan_page = @plan.plan_pages.create(page_no: page_number)
      output_filename = "#{@output_path}/#{@plan.name}_page_#{page_number}.png"
			`pdftoppm -png #{@pdf_path} #{@output_path}/#{@plan.name}_page`
    end
    # plan_pages
  end

  def convert_png_to_tiff
    png_files = Dir.glob(File.join(@output_path, '*.png'))
    png_files.each_with_index do |png_file, index|
      page_no = "#{index + 1}"
      tiff_file_path = File.join(@output_path, "#{@plan.id}_#{@plan.name}_page_#{page_no}.tiff")
      
      # Use Ruby-Vips to convert PNG to TIFF
      img = Vips::Image.new_from_file(png_file)
      img = img.copy xres: 10, yres: 10
      img.write_to_file(tiff_file_path) # Adjust quality (Q) as needed

      # Attach TIFF file to the model using Active Storage
      tiff_file = File.open(tiff_file_path)
      binding.pry
      tiff_blob = ActiveStorage::Blob.create_and_upload!(
        io: tiff_file,
        filename: File.basename(tiff_file_path),
        content_type: 'image/tiff'
      )

      # Associate the attached blob with your model
      plan_page = PlanPage.find_by(page_no: page_no, plan_id: @plan.id)
      plan_page.tiff_file.attach(tiff_blob) if plan_page.present?

      # Close the file handle after attaching
      tiff_file.close
    end
  end

  # def convert_png_to_tiff
  #   png_files = Dir.glob(File.join(@output_path, '*.png'))
  
  #   png_files.each_with_index do |png_file, index|
  #     page_no = "#{index + 1}"
  #     tiff_file_path = File.join(@output_path, "#{@plan.id}_#{@plan.name}_page_#{page_no}.tiff")
  
  #     # Use Ruby-Vips to convert PNG to TIFF
  #     img = Vips::Image.new_from_file(png_file)
  
  #     # Set the xres and yres properties for DPI 100
  #     img.set("xres", 100)
  #     img.set("yres", 100)
  #     binding.pry
  #     # Write the TIFF file
  #     img.write_to_file(tiff_file_path)
  
  #     # Attach TIFF file to the model using Active Storage
  #     tiff_file = File.open(tiff_file_path)
  #     tiff_blob = ActiveStorage::Blob.create_and_upload!(
  #       io: tiff_file,
  #       filename: File.basename(tiff_file_path),
  #       content_type: 'image/tiff'
  #     )
  
  #     # Associate the attached blob with your model
  #     plan_page = PlanPage.find_by(page_no: page_no, plan_id: @plan.id)
  #     plan_page.tiff_file.attach(tiff_blob) if plan_page.present?
  
  #     # Close the file handle after attaching
  #     tiff_file.close
  #   end
  # end
  
  # def convert_png_to_tiff ###converting png to tiff using minimagick gem 
  #   png_files = Dir.glob(File.join(@output_path, '*.png'))
    
  #   png_files.each_with_index do |png_file, index|
	# 		page_no = "#{index + 1}"
  #     tiff_file_path = File.join(@output_path, "page_#{page_no}.tiff")

  #     # Use MiniMagick to convert PNG to TIFF
  #     MiniMagick::Tool::Convert.new do |convert|
  #       convert << png_file
  #       convert.resize "300X200" 
  #       convert << tiff_file_path
  #     end

  #     # Attach TIFF file to the model using Active Storage
  #     tiff_file = File.open(tiff_file_path)
  #     tiff_blob = ActiveStorage::Blob.create_and_upload!(
  #       io: tiff_file,
  #       filename: File.basename(tiff_file_path),
  #       content_type: 'image/tiff'
  #     )

  #     # Associate the attached blob with your model
	# 		plan_page = PlanPage.find_by(page_no: page_no, plan_id: @plan.id)
  #     plan_page.tiff_file.attach(tiff_blob) if plan_page.present?
      
  #     # Close the file handle after attaching
  #     # tiff_file.close
  #   end
  # end
end

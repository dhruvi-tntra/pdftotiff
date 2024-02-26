class Plan < ApplicationRecord
  has_many :plan_pages, dependent: :destroy
  has_one_attached :pdf_file
  validates :name, presence: true
  validate :pdf_file_is_pdf
  # after_create :pdffilename

  def convert_pdf_to_tiff(pdf_path)
    pdf_to_tiff_converter = PdfToTiffConverter.new(pdf_path, self)
    pdf_to_tiff_converter.convert
  end

  def pdffilename
    pdf_file.attachment.blob.filename.to_s if pdf_file.attached?
  end

  def print_composite_image(image1, image2, image3) #image dirs
    image_list = Magick::ImageList.new(image1, image2, image3)
    montaged_images = image_list.montage do |image| 
        image.tile="1x3", image.background_color = "black", self.geometry = "130x194+10+5"
    end
    montaged_images.write("./imgs/compositeimage.png")
    Catpix.print_image("./imgs/compositeimage.png", {limit_x: 0.90, limit_y: 0.90, resolution: "high"})
  end

  private

  def pdf_file_is_pdf
    return unless pdf_file.attached? && !pdf_file.content_type.in?(%w(application/pdf))

    errors.add(:pdf_file, 'must be a PDF')
    pdf_file.purge
  end

  # def convert_pdf_to_tiff
  #   return unless pdf_file.attached?

  #   temp_path = "#{Rails.root}/tmp/#{SecureRandom.hex(8)}"
  #   FileUtils.mkdir_p(temp_path)

  #   begin
  #     # Convert PDF to PNG using pdf2png
  #     system("pdf2png -i #{pdf_file.path} -o #{temp_path}/page.png")

  #     # Convert PNG to TIFF using MiniMagick
  #     Dir.glob("#{temp_path}/*.png").sort.each_with_index do |png_file, index|
  #       tiff_file_path = "#{temp_path}/page_#{index + 1}.tiff"
  #       MiniMagick::Tool::Convert.new do |convert|
  #         convert << png_file
  #         convert << tiff_file_path
  #       end
  #     end

  #     # Attach TIFF files to PlanPage instances
  #     Dir.glob("#{temp_path}/*.tiff").sort.each_with_index do |tiff_file, index|
  #       plan_pages.create(page_no: index + 1).tiff_file.attach(
  #         io: File.open(tiff_file),
  #         filename: File.basename(tiff_file)
  #       )
  #     end
  #   ensure
  #     FileUtils.rm_rf(temp_path)
  #   end
  # end
end

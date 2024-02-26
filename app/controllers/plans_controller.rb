class PlansController < ApplicationController
  # layout "turbo_rails/frame", only: [:new]

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      # pdf_path = "/home/tntra/Documents/Lot 1 - 732056CD Mar03 2023 with Markups.pdf"
      uploaded_file = plan_params[:pdf_file] 
      if uploaded_file.is_a?(ActionDispatch::Http::UploadedFile)
        temp_file_path = uploaded_file.tempfile.path
        puts "Temp file path: #{temp_file_path}"
      else
        puts "Invalid file format or parameter"
      end
      @plan.convert_pdf_to_tiff(temp_file_path)
      redirect_to plans_path, notice: 'Plan was successfully created.'
    else
      render :new
    end
  end

  def show
    @plan = Plan.find(params[:id])
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :pdf_file, :pdffilename)
  end
end

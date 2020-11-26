class ImportsController < ApplicationController

  # GET /imports/new
  def new
    @import = Import.new
  end

  # POST /imports
  # POST /imports.json
  def create
    @import = Import.new(import_params)

    respond_to do |format|
      if @import.save
        format.html { render :new, notice: 'Import was successfully created.' }
        format.json { render :new, status: :created, location: @import }
      else
        format.html { render :new }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def import_params
      params.require(:import).permit(:file, :type)
    end
end

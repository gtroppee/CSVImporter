class ImportsController < ApplicationController
  def new
    @import          = Import.new
    @buildings_count = Building.count
    @people_count    = Person.count
  end

  def create
    @import = Import.new(import_params)

    if @import.save
      render :new, notice: 'Import was successfully processed.'
    else
      render :new
    end
  end

  private
    def import_params
      params.require(:import).permit(:file, :type)
    end
end

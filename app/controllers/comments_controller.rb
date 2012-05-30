class CommentsController < ApplicationController
  # create comment from params
  def create
      @pdf = Vlozitpdf.find(params[:vlozitpdf_id])
      @comment = @pdf.comments.create(params[:comment])
      redirect_to vlozitpdf_path(@pdf)
    end
end

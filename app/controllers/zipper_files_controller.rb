class ZipperFilesController < ApplicationController
  def create
    zipper_file = FileZipping::FileProcessor.new(params_with_user_id).call
    if zipper_file
      prepared_response = FileZipping::ZipPayloadCreator.new(zipper_file, request.base_url).call
      render json: prepared_response
    else
      render json: { error: "Something went wrong." }, status: :unprocessable_entity
    end
  end

  def index
    render json: current_user.includes(:zipper_files).zipper_files.to_json
  end

  private

  def zipper_files_params
    params.permit(:name, :unzipped_file)
  end

  def params_with_user_id
    zipper_files_params.merge(user_id: current_user.id)
  end
end

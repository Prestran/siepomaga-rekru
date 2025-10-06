class ZipperFilesController < ApplicationController
  before_action :authenticate_devise_api_token!

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
    render json: User.includes(:zipper_files).find(Current.user.id).zipper_files.to_json
  end

  private

  def zipper_files_params
    params.permit(:name, :unzipped_file)
  end

  def params_with_user_id
    zipper_files_params.merge(user_id: Current.user.id)
  end
end

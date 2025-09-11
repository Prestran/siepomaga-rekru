class ZipperFilesController < ApplicationController
  allow_unauthenticated_access only: %i[create index]
  before_action :zipper_file, only: [:create]

  def create
    prepared_response = ZipPayloadCreator.new(@zipper_file, request.base_url).call

    if prepared_response
      render json: prepared_response
    else
      render json: { error: "Something went wrong." }, status: :unprocessable_entity
    end
  end

  def index
    render json: User.includes(:zipper_files).find(Current.user.id).zipper_files.to_json
  end

  private

  def zipper_file
    @zipper_file = ZipperFile.create(zipper_files_params.merge(user_id: Current.user.id))
  end

  def zipper_files_params
    params.permit(:name, :unzipped_file)
  end
end

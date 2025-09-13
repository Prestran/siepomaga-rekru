class ZipPayloadCreator
  attr_reader :zipper_file
  def initialize(zipper_file, base_path)
    @zipper_file = zipper_file
    @base_path = base_path
  end

  def call
    prepare_create_response
  end

  private

  def prepare_create_response
    return unless zipper_file.archive_file.attached?

    zipper_file_address = archive_file_path
    decrypted_password = Zip::TraditionalDecrypter.new(zipper_file.archive_password)
    {
      file_url: zipper_file_address,
      file_password: decrypted_password
    }
  end

  def archive_file_path
    @base_path + Rails.application.routes.url_helpers.rails_blob_path(zipper_file.archive_file, only_path: true)
  end
end

class TempFileCleanerJob < ApplicationJob
  queue_as :default

  def perform(path:)
    File.unlink(path) if File.exist?(path)
  end
end

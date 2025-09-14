require "rails_helper"

RSpec.describe TempFileCleanerJob, type: :job do
  context "when file exists" do
    it "deletes the file" do
      tempfile = Tempfile.new("test_file")
      subject.perform(path: tempfile.path)
      expect(File.exist?(tempfile.path)).to eq false
    end
  end
end

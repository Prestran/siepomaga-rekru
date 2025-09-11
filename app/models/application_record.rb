class ApplicationRecord < ActiveRecord::Base
  Zip.force_entry_names_encoding = 'UTF-8'

  primary_abstract_class
end

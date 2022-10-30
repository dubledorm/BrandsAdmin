# frozen_string_literal: true

class BrandFile

  class BuildServiceError < StandardError

    def initialize(error_str)
      super("Ошибка разбора имени файла в заголовке: #{error_str}")
    end
  end

  class BuildService
    REG_FILENAME = /filename="(?<file_path>[^"]+)"/.freeze

    def self.Build(uploaded_file)
      brand_file = BrandFile.new
      brand_file.name = uploaded_file.original_filename
      m = uploaded_file.headers.match(REG_FILENAME)
      raise BrandFile::BuildServiceError, uploaded_file.headers if m.nil? || m[:file_path].nil?

      brand_file.full_name = m[:file_path]
      brand_file
    end
  end
end

# frozen_string_literal: true

class Brand
  # Расширение общего HttpService для работы с коллекцией брэндов
  class AddFileService < HttpService

    def self.add_file(brand, uploaded_file, http_service)
      brand_file = BrandFile::BuildService::Build(uploaded_file)
      content = File.open(uploaded_file.tempfile.path, 'rb', &:read)
      http_service.add_file!(brand.id, brand_file.full_name, Base64.strict_encode64(content))
    end
  end
end

# frozen_string_literal: true


class Brand
  # Расширение общего HttpService для работы с коллекцией брэндов
  class AddFileService < HttpService

    def self.add_file(brand, uploaded_file, http_service)
      brand_file = BrandFile::BuildService::Build(uploaded_file)
      content = File.open(uploaded_file.tempfile.path, 'rb', &:read)
      # body = uploaded_file.read.force_encoding("ISO-8859-1").encode("UTF-8")
      # Base64.encode64('12345') 'MTIzNDU='
      http_service.add_file!(brand.id, brand_file.full_name, Base64.encode64('12345')[0..-2])
    end
  end
end

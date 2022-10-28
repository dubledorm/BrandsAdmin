# frozen_string_literal: true

require 'rails_helper'

FB_ATTRIBUTES = { 'name' => 'style.jpg', 'path' => 'site', 'fullName' => 'site\\style.jpg',
                  'dateCreate' => '2022-10-19T13:16:20.609+00:00' }.freeze
FB_ATTRIBUTES_JSON = '{"name":"style.jpg","path":"site","full_name":"site\\\\style.jpg","date_of_create":"2022-10-19T13:16:20.609+00:00"}'

RSpec.describe BrandFile, type: :model do
  describe 'serialization' do
    let(:subject) { BrandFile.new(FB_ATTRIBUTES) }

    it { expect(subject.name).to eq('style.jpg') }
    it { expect(subject.path).to eq('site') }
    it { expect(subject.full_name).to eq('site\style.jpg') }
    it { expect(subject.date_of_create).to eq('2022-10-19T13:16:20.609+00:00') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(FB_ATTRIBUTES_JSON) }
  end
end

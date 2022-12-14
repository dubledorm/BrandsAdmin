# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BrandFile, type: :model do
  FB_ATTRIBUTES_JSON = '{"id":"10","name":"style.jpg","path":"site","fullName":' \
'"site\\\\style.jpg","dateCreate":"2022-10-19T13:16:20.609+00:00"}'

  describe 'serialization' do
    let(:subject) { BrandFile.new.from_json(FB_ATTRIBUTES_JSON) }

    it { expect(subject.id).to eq('10') }
    it { expect(subject.name).to eq('style.jpg') }
    it { expect(subject.path).to eq('site') }
    it { expect(subject.full_name).to eq('site\style.jpg') }
    it { expect(subject.date_of_create).to eq('2022-10-19T13:16:20.609+00:00') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(FB_ATTRIBUTES_JSON) }
  end
end

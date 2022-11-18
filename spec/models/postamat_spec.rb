# frozen_string_literal: true

require 'rails_helper'

PS_ATTRIBUTES = { 'number' => '111-000', 'url' => 'www.yandex.ru', 'description' => 'Описание',
                  'brandId' => '10', 'createDate' => '2022-10-19T13:16:20.609+00:00',
                  'updateDate' => '2022-10-20T13:16:20.609+00:00' }.freeze
PS_ATTRIBUTES_JSON = '{"id":null,"number":"111-000","url":"www.yandex.ru","brand_id":"10","description":"Описание",' \
'"date_of_create":"2022-10-19T13:16:20.609+00:00","date_of_update":"2022-10-20T13:16:20.609+00:00"}'


RSpec.describe Postamat, type: :model do
  describe 'serialization' do
    let(:subject) { Postamat.new(PS_ATTRIBUTES) }

    it { expect(subject.number).to eq('111-000') }
    it { expect(subject.url).to eq('www.yandex.ru') }
    it { expect(subject.description).to eq('Описание') }
    it { expect(subject.brand_id).to eq('10') }
    it { expect(subject.date_of_create).to eq('2022-10-19T13:16:20.609+00:00') }
    it { expect(subject.date_of_update).to eq('2022-10-20T13:16:20.609+00:00') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(PS_ATTRIBUTES_JSON) }
  end
end

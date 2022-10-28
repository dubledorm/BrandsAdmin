# frozen_string_literal: true

require 'rails_helper'

BH_ATTRIBUTES = { 'isSuccess' => false, 'errorMessage' => 'Ошибка при выгрузке с S3',
                  'dateCreate' => '2022-10-20T09:17:20.156+00:00' }.freeze
BH_ATTRIBUTES_JSON = '{"success":false,"error_message":"Ошибка при выгрузке с S3","date_of_create":"2022-10-20T09:17:20.156+00:00"}'

RSpec.describe BuildingHistory, type: :model do
  describe 'serialization' do
    let(:subject) { BuildingHistory.new(BH_ATTRIBUTES) }

    it { expect(subject.success).to eq(false) }
    it { expect(subject.error_message).to eq('Ошибка при выгрузке с S3') }
    it { expect(subject.date_of_create).to eq('2022-10-20T09:17:20.156+00:00') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(BH_ATTRIBUTES_JSON) }
  end
end

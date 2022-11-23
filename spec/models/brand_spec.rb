# frozen_string_literal: true

require 'rails_helper'

ATTRIBUTES = { 'id' => '634ff7887b473eae24536630', 'name' => 'PickPointTest', 'state' => 'BuildError',
               'files' => [{ 'name' => 'style1.css', 'path' => 'site1', 'fullName' => 'site\\style.css1',
                             'dateCreate' => '2022-10-19T13:13:46.08+00:00' },
                           { 'name' => 'style1.jpg', 'path' => 'site', 'fullName' => 'site\\style.jpg',
                             'dateCreate' => '2022-10-19T13:16:20.609+00:00' }],
               'buildingHistory' => [{ 'isSuccess' => false, 'errorMessage' => 'Ошибка при выгрузке с S3',
                                       'dateCreate' => '2022-10-20T09:17:20.156+00:00' },
                                     { 'isSuccess' => false, 'errorMessage' => 'Ошибка при выгрузке с S3',
                                       'dateCreate' => '2022-10-20T09:19:17.754+00:00' }],
               'dateCreate' => '2022-10-19T13:11:36.441+00:00',
               'dateUpdate' => '2022-10-20T12:44:42.235+00:00' }.freeze
ATTRIBUTES_JSON = '{"name":"style.jpg","path":"site","fullName":"site\\\\style.jpg","dateCreate":"2022-10-19T13:16:20.609+00:00"}'

RSpec.describe Brand, type: :model do

  describe 'serialization' do
    let(:subject) { Brand.new(ATTRIBUTES) }

    it { expect(subject.id).to eq('634ff7887b473eae24536630') }
    it { expect(subject.name).to eq('PickPointTest') }
    it { expect(subject.state).to eq('BuildError') }
    it { expect(subject.date_of_create).to eq('2022-10-19T13:11:36.441+00:00') }
    it { expect(subject.date_of_update).to eq('2022-10-20T12:44:42.235+00:00') }
    it { expect(subject.files.count).to eq(2) }
    it { expect(subject.files[0].name).to eq('style1.css') }
    it { expect(subject.files[0].path).to eq('site1') }
    it { expect(subject.files[0].full_name).to eq('site\\style.css1') }
    it { expect(subject.files[0].date_of_create).to eq('2022-10-19T13:13:46.08+00:00') }
    it { expect(subject.files[1].name).to eq('style1.jpg') }
    it { expect(subject.building_history.count).to eq(2) }
    it { expect(subject.building_history[0].success).to eq(false) }
    it { expect(subject.building_history[0].error_message).to eq('Ошибка при выгрузке с S3') }
    it { expect(subject.building_history[0].date_of_create).to eq('2022-10-20T09:17:20.156+00:00') }
    it { expect(subject).to be_valid }
    it { expect(JSON.parse(subject.to_json)['files'].count).to eq(2) }
  end

  describe 'simple brand' do
    it { expect(Brand.new({ name: 'test' })).to be_valid }
    it { expect(Brand.new({})).to be_invalid }
  end
end

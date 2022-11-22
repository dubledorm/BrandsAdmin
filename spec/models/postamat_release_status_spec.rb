# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostamatReleaseStatus, type: :model do
  ERROR_ATTRIBUTES1 = { 'message' => '123-1', 'detail' => '456-1', 'dateCreate' => '2022-11-17T09:18:48.852Z' }.freeze
  ERROR_ATTRIBUTES2 = { 'message' => '123-2', 'detail' => '456-2', 'dateCreate' => '2022-11-17T09:18:48.852Z' }.freeze
  PRS_ATTRIBUTES = { 'number' => '123-456', 'status' => 'New', 'errors' =>
    [ERROR_ATTRIBUTES1, ERROR_ATTRIBUTES2] }.freeze
  PRS_ATTRIBUTES_JSON = '{"postamat_number":"123-456","state":"New",' \
'"date_of_create":null,"date_of_update":null,"errors":' \
'[{"message":"123-1","detail_message":"456-1","date_of_create":"2022-11-17T09:18:48.852Z"},' \
'{"message":"123-2","detail_message":"456-2","date_of_create":"2022-11-17T09:18:48.852Z"}]}'


  describe 'serialization' do
    let(:subject) { PostamatReleaseStatus.new(PRS_ATTRIBUTES) }

    it { expect(subject.postamat_number).to eq('123-456') }
    it { expect(subject.state).to eq('New') }
    it { expect(subject.errors.count).to eq(2) }
    it { expect(subject.errors[0].message).to eq('123-1') }
    it { expect(subject.errors[1].detail_message).to eq('456-2') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(PRS_ATTRIBUTES_JSON) }

  end
end

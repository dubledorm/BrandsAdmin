# frozen_string_literal: true

require 'rails_helper'

RE_ATTRIBUTES = { 'message' => '123', 'details' => '456', 'dateCreate' => '2022-11-17T09:18:48.852Z' }.freeze
RE_ATTRIBUTES_JSON = '{"message":"123","detail_message":"456","date_of_create":"2022-11-17T09:18:48.852Z"}'


RSpec.describe ReleaseError, type: :model do
  describe 'serialization' do
    let(:subject) { ReleaseError.new(RE_ATTRIBUTES) }

    it { expect(subject.message).to eq('123') }
    it { expect(subject.detail_message).to eq('456') }
    it { expect(subject.date_of_create).to eq('2022-11-17T09:18:48.852Z') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(RE_ATTRIBUTES_JSON) }
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReleaseError, type: :model do
  RE_ATTRIBUTES_JSON = '{"message":"123","details":"456","dateCreate":"2022-11-17T09:18:48.852Z"}'

  describe 'serialization' do
    let(:subject) { ReleaseError.new.from_json(RE_ATTRIBUTES_JSON) }

    it { expect(subject.message).to eq('123') }
    it { expect(subject.detail_message).to eq('456') }
    it { expect(subject.date_of_create).to eq('2022-11-17T09:18:48.852Z') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(RE_ATTRIBUTES_JSON) }
  end
end

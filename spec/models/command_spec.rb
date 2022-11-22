# frozen_string_literal: true

require 'rails_helper'

CM_ATTRIBUTES = { 'id' => '123', 'brandId' => '456', 'brandName' => 'name_of_brand',
                  'status' => 'completed', 'build' => '789',
                  'postamats' => %w[123-03 123-09] }.freeze
CM_ATTRIBUTES_JSON = '{"id":"123","brand_id":"456","brand_name":"name_of_brand","state":"completed",' \
'"build_url":"789","date_of_create":null,"postamats":["123-03","123-09"]}'


RSpec.describe Command, type: :model do
  describe 'serialization' do
    let(:subject) { Command.new(CM_ATTRIBUTES) }

    it { expect(subject.id).to eq('123') }
    it { expect(subject.brand_id).to eq('456') }
    it { expect(subject.brand_name).to eq('name_of_brand') }
    it { expect(subject.state).to eq('completed') }
    it { expect(subject.build_url).to eq('789') }
    it { expect(subject.postamats.count).to eq(2) }
    it { expect(subject.postamats[0]).to eq('123-03') }
    it { expect(subject.postamats[1]).to eq('123-09') }
    it { expect(subject).to be_valid }
    it { expect(subject.to_json).to eq(CM_ATTRIBUTES_JSON) }
  end
end

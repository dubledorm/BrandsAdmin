# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Command, type: :model do
  CS_ATTRIBUTES = { 'data' => [{ "number": "123-456",
                                 "status": "New",
                                 "dateCreate": "2022-11-19T18:23:38.502Z",
                                 "dateUpdate": "2022-11-19T18:23:38.502Z",
                                 "errors": [
                                   { "message": "message1",
                                     "detail": "detail1",
                                     "dateCreate": "2022-11-19T18:23:38.502Z" },
                                   { "message": "message2",
                                     "detail": "detail2",
                                     "dateCreate": "2022-11-20T18:23:38.502Z" }
                                 ] },
                                   { "number": "123-457",
                                     "status": "Completed",
                                     "dateCreate": "2022-11-21T18:23:38.502Z",
                                     "dateUpdate": "2022-11-21T18:23:38.502Z",
                                     "errors": [] }] }.freeze

  describe 'serialization' do
    let(:subject) { CommandStatus.new(CS_ATTRIBUTES) }

    it { expect(subject.postamat_release_statuses.count).to eq(2) }
    it { expect(subject.postamat_release_statuses[0].postamat_number).to eq('123-456') }
    it { expect(subject.postamat_release_statuses[0].state).to eq('New') }
    it { expect(subject.postamat_release_statuses[0].date_of_create).to eq('2022-11-19T18:23:38.502Z') }
    it { expect(subject.postamat_release_statuses[0].date_of_update).to eq('2022-11-19T18:23:38.502Z') }
    it { expect(subject.postamat_release_statuses[0].errors.count).to eq(2) }
    it { expect(subject.postamat_release_statuses[0].errors[0].message).to eq('message1') }
    it { expect(subject.postamat_release_statuses[0].errors[0].detail_message).to eq('detail1') }
    it { expect(subject.postamat_release_statuses[0].errors[0].date_of_create).to eq('2022-11-19T18:23:38.502Z') }
    it { expect(subject.postamat_release_statuses[0].errors[1].message).to eq('message2') }
    it { expect(subject).to be_valid }
    #it { expect(subject.to_json).to eq(CM_ATTRIBUTES_JSON) }
  end
end

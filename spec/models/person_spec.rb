require 'rails_helper'

RSpec.describe Person, type: :model do
  it_behaves_like "a versionable resource"
  it_behaves_like "an importable resource", {
    filtered_fields: described_class::FILTERED_FIELDS,
    unfiltered_fields: %i(firstname lastname),
    headers: %w(reference email home_phone_number mobile_phone_number firstname lastname address),
    rows: [
      ['1',	'Henri', 'Dupont',	'0123456789',	'0623456789',	'h.dupont@gmail.com',	'10 Rue La bruyère'],
      ['2',	'Jean', 'Durand',	'0123336789',	'0663456789',	'jdurand@gmail.com',	'40 Rue René Clair']
    ]
  }
end

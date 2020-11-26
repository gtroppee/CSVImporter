require 'rails_helper'

RSpec.describe Building, :focus, type: :model do
  it_behaves_like "a versionable resource"
  it_behaves_like "an importable resource", {
    filtered_fields: described_class::FILTERED_FIELDS,
    unfiltered_fields: %i(address zip_code city country),
    headers: %w(reference address zip_code city country manager_name),
    rows: [
      ['1', '10 Rue La bruyère', '75009', 'Paris', 'France', 'Martin Faure'],
      ['2', '40 Rue René Clair', '75018', 'Paris', 'France', 'Martin Faure']
    ]
  }
end

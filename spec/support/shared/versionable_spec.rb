RSpec.shared_examples "a versionable resource" do
  subject { create(described_class.to_s.underscore.to_sym) }
  let(:random_value) { Faker::Internet.uuid }

  describe "has_had_value_for?" do
    context 'when the given field value has not previously been set' do
      it "returns false" do
        expect(subject).not_to have_had_value_for(:address, random_value)
      end
    end

    context 'when the given field value has previously been set' do
      before { subject.update(address: random_value) }

      it "returns true" do
        expect(subject).to have_had_value_for(:address, random_value)
      end
    end
  end
end
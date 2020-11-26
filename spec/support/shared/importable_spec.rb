RSpec.shared_examples "an importable resource" do |configuration|
  filtered_fields   = configuration[:filtered_fields]
  unfiltered_fields = configuration[:unfiltered_fields]
  row_size          = configuration[:rows].first.size

  let!(:headers)    { configuration[:headers] }
  let!(:rows)       { configuration[:rows] }

  let!(:csv_file) do
    file = Tempfile.new('csv_data')
    CSV.open(file, 'w', headers: true) do |csv|
      csv << headers
      rows.each { |row| csv << row }
    end
    file
  end

  let(:resource1) { described_class.find_or_create_by(reference: '1') }
  let(:resource2) { described_class.find_or_create_by(reference: '2') }

  subject { Import.new({ file: csv_file, type: described_class.to_s }) }

  describe '#save' do
    context 'when no records exist' do
      it 'creates all the records' do
        expect { subject.save }.to change(described_class, :count).by(2)
      end
    end

    context 'when a record exists', :focus do
      before { create(described_class.to_s.underscore.to_sym, reference: '1') }

      describe 'fields filtering' do
        let(:rows) do
          [(['1'] + (['value1'] * (row_size - 1)))]
        end

        filtered_fields.each do |field|
          context "when the given value has never been set for ##{field}" do
            it 'updates the existing record with the given value' do
              subject.save
              expect(resource1.reload.public_send(field)).to eq('value1')
            end
          end

          context "when the given value has already been set for ##{field}" do
            before do 
              resource1.update(field => 'value1')
              resource1.update(field => 'value2') 
            end

            it "does not update the existing record for ##{field}" do
              subject.save  
              expect(resource1.reload.public_send(field)).to eq('value2')
            end
          end
        end

        unfiltered_fields.each do |field|
          context "when the given value has never been set for ##{field}" do
            it 'updates the existing record with the given value' do
              subject.save
              expect(resource1.reload.public_send(field)).to eq('value1')
            end
          end

          context "when the given value has already been set for ##{field}" do
            before do 
              resource1.update(field => 'value1')
              resource1.update(field => 'value2') 
            end

            it "updates the existing record for ##{field}" do
              subject.save  
              expect(resource1.reload.public_send(field)).to eq('value1')
            end
          end
        end
      end
    end
  end
end
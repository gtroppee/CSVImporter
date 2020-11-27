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

  let(:resource) { described_class.find_or_create_by(reference: '1') }

  subject { Import.new({ file: csv_file, type: described_class.to_s }) }

  describe '#save' do
    context 'when no records exist' do
      it 'creates all the records' do
        expect { subject.save }.to change(described_class, :count).by(2)
      end
    end

    context 'when a record exists' do
      before { create(described_class.to_s.underscore.to_sym, reference: '1') }

      it 'creates only the missing records' do
        expect { subject.save }.to change(described_class, :count).by(1)
      end

      describe 'fields filtering' do
        let(:rows) do
          [(['1'] + (['value1'] * (row_size - 1)))]
        end

        filtered_fields.each do |field|
          context "when the given value has never been set for ##{field}" do
            it 'updates the existing record with the given value' do
              subject.save
              expect(resource.reload.public_send(field)).to eq('value1')
            end
          end

          context "when the given value has already been set for ##{field}" do
            before do 
              resource.update(field => 'value1')
              resource.update(field => 'value2') 
            end

            it "does not update the existing record for ##{field}" do
              subject.save  
              expect(resource.reload.public_send(field)).to eq('value2')
            end
          end
        end

        unfiltered_fields.each do |field|
          context "when the given value has never been set for ##{field}" do
            it 'updates the existing record with the given value' do
              subject.save
              expect(resource.reload.public_send(field)).to eq('value1')
            end
          end

          context "when the given value has already been set for ##{field}" do
            before do 
              resource.update(field => 'value1')
              resource.update(field => 'value2') 
            end

            it "updates the existing record for ##{field}" do
              subject.save  
              expect(resource.reload.public_send(field)).to eq('value1')
            end
          end
        end
      end
    end
  end
end
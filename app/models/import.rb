class Import
  include ActiveModel::Model
  attr_accessor :file, :type, :data, :headers, :rows, :rows_for_creation, :rows_for_update, :rows_attributes

  def save
    self.data            = CSV.read(file)
    self.headers         = data[0]
    self.rows            = data[1..-1]
    self.rows_attributes = rows_to_attributes
    @resource_class      = type.constantize
    process_rows

    ActiveRecord::Base.transaction do
      create_records if rows_for_creation.any?
      update_records if rows_for_update.any?
    end
  end

  private

  def create_records
    add_timestamps!(rows_for_creation)
    @resource_class.insert_all(rows_for_creation)
  end

  def update_records
    add_timestamps!(rows_for_update, created_at: false)
    @resource_class.upsert_all(rows_for_update)
  end

  def add_timestamps!(attributes, created_at: true, updated_at: true)
    now = Time.zone.now
    attributes.each do |attributes_hash|
      attributes_hash[:created_at] = now if created_at
      attributes_hash[:updated_at] = now if updated_at
    end
  end

  def rows_to_attributes
    rows.map do |row|
      hash = {}
      row.each_with_index do |value, index|
        hash[headers[index].to_sym] = value
      end
      hash
    end
  end

  def process_rows
    # Get the references of all existing records associated to the file
    references = rows_attributes.map { |row| row[:reference] }
    existing_records = @resource_class.where(reference: references)
    existing_references = existing_records.map(&:reference)
    
    # Make two batches of attributes: one will servce for the creation request, the other for the update request
    self.rows_for_update, self.rows_for_creation = rows_attributes.partition do |row|
      existing_references.include?(row[:reference])
    end

    # Filter the update attributes: new values for the models' FILTERED_FIELDS will be taken into account only if they have never been set to said values.
    rows_for_update.each do |attributes|
      associated_record = existing_records.detect { |record| record.reference === attributes[:reference] }
      attributes.merge!(id: associated_record&.id, created_at: associated_record&.created_at)

      @resource_class::FILTERED_FIELDS.each do |field|
        if associated_record.has_had_value_for?(field, attributes[field])
          attributes.merge!(field => associated_record.public_send(field))
        end
      end
    end
  end
end

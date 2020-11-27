module Versionable
  extend ActiveSupport::Concern

  included do
    serialize :versions
    before_save :version

    def self.insert_all(attributes, returning: nil, unique_by: nil)
      attributes.each do |attribute| attribute[:versions] = [attribute] end
      super
    end

    def self.upsert_all(attributes, returning: nil, unique_by: nil)
      attributes.each do |attribute| attribute[:versions] = [attribute] end
      super
    end

    def version
      self.versions << attributes.except('versions')
    end

    def has_had_value_for?(field, value)
      versions.any? do |version|
        version[field.to_s] === value
      end
    end
  end
end
# frozen_string_literal: true

class APIVersion

  include ActiveModel::Model
  include ActiveModel::Attributes

  VERSIONS = %w[v1].freeze

  attribute :version, :string

  validates :version, presence: true, inclusion: { in: VERSIONS }

  def initialize(version)
    super(version: version.to_s.downcase)
  end

  VERSIONS.each do |ver|
    define_method("#{ver}?") do
      version == ver
    end
  end

end

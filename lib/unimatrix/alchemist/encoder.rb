module Unimatrix::Alchemist

  class Encoder < Unimatrix::DynamicResource

    field :id
    field :uuid
    field :state
    field :realm_uuid
    field :created_at
    field :updated_at

    has_many :rendition_profiles
    has_many :videos

  end

end
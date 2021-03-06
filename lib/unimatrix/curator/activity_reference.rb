module Unimatrix::Curator

  class ActivityReference < Unimatrix::DynamicResource
    field    :id
    field    :type_name
    field    :subject_uuid
    field    :subject_type
    field    :state
    field    :message
    field    :properties
    field    :source_uuid
    field    :completed_at
    field    :destroyed_at
    field    :created_at
    field    :updated_at
    field    :execute_at

    has_one  :realm
  end

end

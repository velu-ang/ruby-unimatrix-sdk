module Unimatrix::Archivist

  class Component < Unimatrix::DynamicResource
    
    field    :id
    field    :uuid
    field    :realm_uuid
    field    :type_name
    field    :created_at
    field    :updated_at
    
    has_one  :artifact
    has_many :errors

  end

end

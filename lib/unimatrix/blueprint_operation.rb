module Unimatrix

  class BlueprintOperation < Unimatrix::Operation

    @@blueprints = {}

    def initialize( realm_uuid, options = {} )
      @realm_uuid = realm_uuid
      super( "/realms/#{ realm_uuid }/blueprints", options )
    end

    def read     
      @@blueprints[ @realm_uuid ] ||= begin

        blueprints = []

        offset = 0
        segment_count = 10
        total = nil

        operation = self.offset( offset ).include( 'blueprint_attributes' )

        while total.nil? || offset < total
          operation.read do | resources, response |
            response = response.body[ '$this' ]

            offset += segment_count
            total = response[ 'unlimited_count' ]

            blueprints += resources

            operation = self.offset( offset ).include( 'blueprint_attributes' )
          end
        end 
# check if any fail, then fail the operation
        blueprints

      end  
    end

  end
end
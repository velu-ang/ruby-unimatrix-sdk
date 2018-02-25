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
        errors = nil

        while total.nil? || offset < total
          operation.read do | resources, response |

            binding.pry
            if !response.body[ 'errors' ].nil?
              errors = response.body[ 'errors' ]
              break
            end

            offset += segment_count
            total = response.body[ '$this' ][ 'unlimited_count' ]

            blueprints += resources

            operation = self.offset( offset ).include( 'blueprint_attributes' )
          end

          break if !errors.nil?
        end

        blueprints

      end
    end

  end
end

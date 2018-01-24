module Unimatrix

  class Blueprintable < Resource

    class << self

      alias build new

      def new( attributes = {}, associations = {} )
        klass = get_class( attributes.with_indifferent_access )

        klass.build(
          attributes,
          associations
        )
      end

      def get_class( attributes )
        module_name = Unimatrix.const_get( self.name.split( '::' )[1].underscore.camelize )
        entity_name = self.name.split( '::' ).last.underscore.camelize
        entity_type_name = attributes[ 'type_name' ].camelize

        klass = ( module_name.const_get( entity_name ) rescue nil )

        unless module_name.const_defined?( entity_type_name )
          typed_klass = Class.new( klass )
          klass = module_name.const_set( entity_type_name, typed_klass )
        else
          klass = module_name.const_get( entity_type_name )
        end
      end

    end


    def initialize( attributes = {}, associations = {} )
      attributes =  attributes.with_indifferent_access

      blueprints =
        Unimatrix::Operation.new(
          "/realms/#{ attributes[ "realm_uuid" ] }/blueprints",
          { access_token: token }
        ).where( {
          "resource_type_name": attributes[ "type_name" ]
        } ).include (
          "blueprint_attributes"
        )

      blueprints = blueprints.read

      unless blueprints.empty?
        blueprint = blueprints.first rescue nil

        #Always prefer realm-scoped blueprint
        blueprints.each do | b |
          unless b.realm_uuid.nil?
            blueprint = b
          end
        end

        if blueprint.respond_to?( 'blueprint_attributes' )
          blueprint_attributes = blueprint.blueprint_attributes

          self.class_eval do
            blueprint_attributes.each do | attribute |
              field attribute.name
            end
          end
        end
      end

      super( attributes, associations )
    end

    protected; def token
      @authorization_token ||= begin
         Unimatrix::Authorization::ClientCredentialsGrant.new(
           client_id:     ENV[ 'KEYMAKER_CLIENT' ],
           client_secret: ENV[ 'KEYMAKER_SECRET' ]
         ).request_token
      end
    end

  end

end

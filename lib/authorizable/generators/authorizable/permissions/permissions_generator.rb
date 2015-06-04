module Authorizable
  module Generators
    class PermissionsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_permissions
        copy_file "permissions.rb", "config/initializers/permissions.rb"
      end
    end
  end
end

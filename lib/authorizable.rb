require 'active_record'
require 'active_support'
require 'action_controller'

require 'authorizable/error/authorizable_error'
require 'authorizable/error/not_authorized'
require 'authorizable/error/permission_not_found'
require 'authorizable/cache'
require 'authorizable/permission_utilities'
require 'authorizable/permissions'
require 'authorizable/controller'
require 'authorizable/proxy'
require 'authorizable/model'
require 'authorizable/view_helpers'
require 'authorizable/version'

module Authorizable
  OBJECT = PermissionUtilities::OBJECT
  ACCESS = PermissionUtilities::ACCESS

  def self.definitions
    Authorizable::Permissions.definitions || {}
  end
end

# add authorizable method to ActionController
ActionController::Base.send(:include, Authorizable::Controller)

# add authorizable method to ActiveModel
ActiveRecord::Base.send(:include, Authorizable::Model)

# include view helpers
ActiveSupport.on_load(:action_view) do
  include Authorizable::ViewHelpers
end

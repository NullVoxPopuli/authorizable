require 'active_record'
require 'active_support'
require 'action_controller'

require 'authorizable/permission_utilities'
require 'authorizable/permissions'
require 'authorizable/controller'
require 'authorizable/model'
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
# class ActionController::Base
#   include Authorizable::Controller

#   def self.authorizable
#     ap 'wat'
#   end
# end

# add authorizable method to ActiveModel
# ActiveRecord::Base.send( :extend, Authorizable::Model )

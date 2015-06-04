require 'active_record'
require 'active_support'
require 'action_controller'
require 'active_support/i18n'

require 'authorizable/configuration'
require 'authorizable/error/authorizable_error'
require 'authorizable/error/controller_config_invalid'
require 'authorizable/error/not_authorized'
require 'authorizable/error/permission_not_found'
require 'authorizable/cache'
require 'authorizable/permission_utilities'
require 'authorizable/permissions'
require 'authorizable/controller/default_config'
require 'authorizable/controller/class_methods'
require 'authorizable/controller'
require 'authorizable/proxy'
require 'authorizable/model'
require 'authorizable/view_helpers'
require 'authorizable/version'

# TODO: In a rails environment, we'd want to install these
# to the rails' config/locals directory
I18n.locale = :en
puts Dir['config/locales/*.yml']
I18n.load_path = Dir['config/locales/*.yml']
I18n.backend.load_translations


module Authorizable
  OBJECT = PermissionUtilities::OBJECT
  ACCESS = PermissionUtilities::ACCESS

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  # to configure Authorizable:
  # in an initializer, you may want to do something like:
  #
  #    Authorizable.configure do |config|
  #      config.flash_error = :alert
  #      config.flash_ok    = :notice
  #    end
  #
  def self.configure
    yield(configuration)
  end

  def self.reset_config!
    @configuration = nil
  end

  def self.definitions
    Authorizable::Permissions.definitions || {}
  end

end

# add authorizable method to ActionController
# the methods in this included module are not executed unless
#
#     authorizable({ config is optional })
#
# is included in the controller.
# Note that the before_action call should happen after the
# controller's resource is loaded
ActionController::Base.send(:include, Authorizable::Controller)

# add authorizable method to ActiveModel
# TODO: Add initialization option to not include this by default
ActiveRecord::Base.send(:include, Authorizable::Model)

# include view helpers
ActiveSupport.on_load(:action_view) do
  include Authorizable::ViewHelpers
end

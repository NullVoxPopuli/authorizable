module Authorizable
  class Configuration
    attr_accessor :flash_error
    attr_accessor :flash_ok
    attr_accessor :flash_success
    attr_accessor :raise_exception_on_denial

    # defaults
    #
    # these match up to css classes used in the
    # foundation framework
    def initialize
      @flash_error                = :alert
      @flash_ok                   = :notice
      @flash_success              = :success
      @raise_exception_on_denial = false
    end
  end
end

module Authorizable
  module Controller
    module DefaultConfig

      index_config = {

      }

      def self.config
        {
          index: {},
          create: {},
          show: {},
          edit: {},
          update: {},
          destroy: {}
        }
      end

    end
  end
end

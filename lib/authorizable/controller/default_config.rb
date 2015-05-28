module Authorizable
  module Controller
    module DefaultConfig

      index_config = {
        permission: :view_all
        redirect_path: Proc.new{ root_path }
      }

      create_config = {
        redirect_path: Proc.new{ action: :index }
      }

      edit_config = {
        redirect_path: Proc.new{ action: :index }
      }

      update_config = edit_config

      destroy_config = {}

      def self.config
        {
          index: index_config,
          create: create_config,
          show: show_config,
          edit: edit_config,
          update: update_config,
          destroy: destroy_config
        }
      end

    end
  end
end

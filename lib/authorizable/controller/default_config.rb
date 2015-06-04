module Authorizable
  module Controller
    module DefaultConfig

      def self.index_config
        {
          permission: :view_all_users,
          redirect_path: Proc.new{ root_path }
        }
      end

      def self.create_config
        {
          redirect_path: ->{ {action: :index} }
        }
      end

      def self.edit_config
        {
          redirect_path: ->{ {action: :index} }
        }
      end

      def self.update_config
        edit_config
      end

      def self.destroy_config
        {
          redirect_path: ->{ {action: :index} }
        }
      end

      def self.show_config
       {
         redirect_path: ->{ {action: :index} }
       }
      end

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

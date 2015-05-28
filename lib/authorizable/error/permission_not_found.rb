module Authorizable
  module Error
    # thrown when a permission is not found
    # - this usually means that the permission just isn't defined
    class PermissionNotFound < AuthorizableError
      def initialize(message: nil, action: nil, subject: nil)
        @default_message = I18n.t("authorizable.permission_not_found")
        super
      end
    end
  end
end

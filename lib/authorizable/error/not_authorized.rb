module Authorizable
  module Error
    class NotAuthorized < AuthorizableError

      def initialize(message: nil, action: nil, subject: nil)
        @default_message = I18n.t("authorizable.not_authorized")
        super
      end
    end
  end
end

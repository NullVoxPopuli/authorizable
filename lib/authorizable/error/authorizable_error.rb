module Authorizable
  module Error
    class AuthorizableError < StandardError
      attr_reader :action, :subject
      attr_accessor :default_message

      def initialize(message: nil, action: nil, subject: nil)
        @message = message
        @action = action
        @subject = subject
        @default_message ||= I18n.t("authorizable.error")
      end

      def to_s
        @message || @default_message
      end
    end
  end
end

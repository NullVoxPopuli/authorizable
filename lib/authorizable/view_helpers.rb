module Authorizable
  module ViewHelpers

    # support can-can style permission checking
    #
    # @example
    #   <% if can? :update, @article %>
    #     <%= link_to "Edit", edit_article_path(@article) %>
    #   <% end %>
    #
    # @param [Symbol] permission the action or permission to check
    # @param [Object] the object to check if the current use can
    #   perform the action on
    # @return [Boolean] true if authorized
    def can?(action, *args)
      current_user.can?(action, *args)
    end

    # Inverse of can?
    def cannot?(*args)
      !can?(*args)
    end

  end
end

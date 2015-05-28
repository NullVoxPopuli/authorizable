module Authorizable

  # the cache is only used per-instance, as it's possible that someone in a
  # web app environment would change the permissions while the user whos
  # permissions we care about is using the app.
  # Permissions would then be 'refreshed' per-page load.
  # No need to re-login
  class Cache


    def store
      @permission_cache ||= {}
    end

    # calculating the value of a permission is costly.
    # there are several Database lookups and lots of merging
    # of hashes.
    # once a permission is calculated, we'll store it here, so we don't
    # have to re-calculate/query/merge everything all over again
    #
    # for both object access and page access, check if we've
    # already calculated the permission
    #
    # the structure of this cache is the following:
    # {
    #   role_1: {
    #     permission1: true
    #     permission2: false
    #   },
    #   authorization_permission_name: true
    # }
    #
    # @param [String] name name of the permission
    # @param [Number] role role of the user
    # @param [Boolean] value
    def set_for_role(name: "", role: nil, value: nil)
      if role
        store[role] ||= {}
        store[role][name] = value
      else
        store[name] = value
      end
    end

    # @param [String] permission_name name of the permission
    # @param [Number] role role of the user
    # @return [Boolean] value of the previously stored permission
    def get_for_role(permission_name, role = nil)
      if role
        store[role] ||= {}
        store[role][permission_name]
      else
        store[permission_name]
      end
    end
  end
end

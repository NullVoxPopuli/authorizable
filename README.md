authorizable
============

A gem for rails giving vast flexibility in authorization management.

[![docs](https://img.shields.io/badge/docs-yardoc-blue.svg?style=flat-square)](http://www.rubydoc.info/github/NullVoxPopuli/authorizable)
[![Gem Version](http://img.shields.io/gem/v/authorizable.svg?style=flat-square)](http://badge.fury.io/rb/authorizable)
[![Build Status](http://img.shields.io/travis/NullVoxPopuli/authorizable.svg?style=flat-square)](https://travis-ci.org/NullVoxPopuli/authorizable)
[![Code Climate](http://img.shields.io/codeclimate/github/NullVoxPopuli/authorizable.svg?style=flat-square)](https://codeclimate.com/github/NullVoxPopuli/authorizable)
[![Test Coverage](http://img.shields.io/codeclimate/coverage/github/NullVoxPopuli/authorizable.svg?style=flat-square)](https://codeclimate.com/github/NullVoxPopuli/authorizable)
[![Dependency Status](http://img.shields.io/gemnasium/NullVoxPopuli/authorizable.svg?style=flat-square)](https://gemnasium.com/NullVoxPopuli/authorizable)


## Features

 - Customizable Permissions
 - Permissions are all defined in one place
 - Role-Based
 - Easy UI Generation
 - Categorization for Organizing Permission in the UI
 - Easily Extensible (e.g.: adding support for permission groups )
 - Automatic controller response upon unauthorized status
 - Controller response is customizable
 - Controller behavior defined in one place (optionally in the controller)

## Installation

Gemfile

    gem "authorizable"

Terminal

    gem install authorizable

## Configuration

### Global Configuration

Configuration can be handled in any of your environment.rb files or in an initializer via

    Authorizable.configure do |config|
      # example configuration option
      config.flash_error = :error # default :alert
    end

Available configuration options are:

- flash_error - `:alert`  
  Used for the flash key whenever Authorizable renders an unauthorized flash message.
- flash_ok - `:notice`  
  Currently unused
- flash_success - `:success`  
  Currently unused
- raise_exception_on_denial - `false`  
  Instead of rendering or redirecting by default, an exception will be raised. `Authorizable::Error::NotAuthorized` will be thrown. Handling of the error may be
  customized by calling `rescue_from` in your controller.

      rescue_from Authorizable::Error::NotAuthorized do |exception|
        redirect_to root_path, notice: "You can't do that, yo."
      end

  or if you want to render a static file

      rescue_from Authorizable::Error::NotAuthorized do |exception|
        render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
      end  

### Defining permissions

There are a couple ways that permissions can be defined.

If you like calling methods for configuration:

    module Authorizable
      class Permissions
        can :delete_event
      end
    end

will create a permission definition called `delete_event` which can be accessed by calling
`user.can_delete_event?(@event)`

    module Authorizable
      class Permissions
        can :edit_event, true, "Edit an Event", nil, ->(e, user){ e.user == user }
      end
    end

will create a permission definition called `edit_event` with an additional condition allowing editing only if the user owns the event

    Authorizable::Permissions.set(
      edit_organization:   [Authorizable::OBJECT, true],
      delete_organization: [Authorizable::OBJECT, [true, false], nil, ->(e, user){ e.user == user }, ->(e, user){ e.owner == user }]
    )

This is how Authorizable references the permission definitions internally, just as raw permission: definition sets. Note that `Authorizable::Permissions.set` overrides the definitions list each time.

### Handling Controller Authorization

### Error In the Controller



### Customizing roles

coming soon...

### Supporting group-based permissions

coming soon...

## Why not CanCan?

Initially, I wanted something more customizable and that could aid in the generation of a UI where users
can customize permissions for various groups or organizations. My goal is to at least support everything CanCan has, but with the mindset and intention of customizing behavior and remaining DRY.

## Contributing

1. Fork the project
2. Create a new, descriptively named branch
3. Add Test(s)!
4. Commit your proposed changes
5. Submit a pull request

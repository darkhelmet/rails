require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module AbstractController
  class DoubleRenderError < Error
    DEFAULT_MESSAGE = "Render and/or redirect were called multiple times in this action. Please note that you may only call render OR redirect, and at most once per action. Also note that neither redirect nor render terminate execution of the action, so if you want to exit an action after redirecting, you need to do something like \"redirect_to(...) and return\"."

    def initialize(message = nil)
      super(message || DEFAULT_MESSAGE)
    end
  end

  module Rendering
    extend ActiveSupport::Concern

    included do
      class_attribute :protected_instance_variables
      self.protected_instance_variables = []
    end

    # Raw rendering of a template to a string.
    #
    # It is similar to render, except that it does not
    # set the response_body and it should be guaranteed
    # to always return a string.
    #
    # If a component extends the semantics of response_body
    # (as Action Controller extends it to be anything that
    # responds to the method each), this method needs to be
    # overridden in order to still return a string.
    # :api: plugin
    def render_to_string(*args, &block)
    end

    # Raw rendering of a template.
    # :api: plugin
    def render_to_body(options = {})
    end

    # Normalize arguments, options and then delegates render_to_body and
    # sticks the result in self.response_body.
    # :api: public
    def render(*args, &block)
    end

    # Return Content-Type of rendered content
    # :api: public
    def rendered_format
    end

    DEFAULT_PROTECTED_INSTANCE_VARIABLES = %w(
      @_action_name @_response_body @_formats @_prefixes @_config
      @_view_context_class @_view_renderer @_lookup_context
    )

    # This method should return a hash with assigns.
    # You can overwrite this configuration per controller.
    # :api: public
    def view_assigns
      hash = {}
      variables  = instance_variables
      variables -= protected_instance_variables
      variables -= DEFAULT_PROTECTED_INSTANCE_VARIABLES
      variables.each { |name| hash[name[1..-1]] = instance_variable_get(name) }
      hash
    end

    # Normalize args by converting render "foo" to render :action => "foo" and
    # render "foo/bar" to render :file => "foo/bar".
    # :api: plugin
    def _normalize_args(action=nil, options={})
      options
    end

    # Normalize options.
    # :api: plugin
    def _normalize_options(options)
      options
    end

    # Process extra options.
    # :api: plugin
    def _process_options(options)
      options
    end
  end
end

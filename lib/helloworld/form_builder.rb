require "action_view"
module Helloworld
  # Simple form builder to privide forms matching the css styles.
  # 
  # Usage:
  #   <%= form_for @foo, ... , :builder => Helloworld::FormBuilder do |f| %>
  #     ...
  #   <% end %>  
  # 
  # See http://openmonkey.com/articles/2010/03/rails-labels-with-blocks
  class FormBuilder < ActionView::Helpers::FormBuilder

    # Renders a 'block' (a <li> element) holding the contents of the given
    # <i>&block</i>.
    #
    # The <li> element will be annotated with the class 'error' if the attribute
    # matching the given _method_ has an error.
    def block(method, options = {}, &block)
      options = options.stringify_keys
      if errors_on?(method)
        (options['class'] = options['class'].to_s + ' error').strip!
      end

      @template.content_tag(:li, options, &block)
    end

    private

    # Are there error messages for the given attribute?
    def errors_on?(method)
      @object.respond_to?(:errors) && @object.errors[method.to_sym].present?
    end
  end
end

# Remove the rails error span from fields with errors.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag
end

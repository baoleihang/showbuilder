require 'view_builder/builders/template_methods'
require 'view_builder/i18n_text'

module ViewBuilder
  module Builders
    class FormBuilder
      include ViewBuilder::Builders::TemplateMethods
      include ViewBuilder::I18nText

      def initialize(template)
        @template = template
      end

      def show_text_input(method)
        self.show_method_input(method) do
          self.text_field_tag(method, nil, :class => 'xlarge', :id => 'xlInput')
        end
      end

      def show_email_input(method)
        self.show_method_input(method) do
          self.contents_tag(:div, :class => "input-append") do |contents|
            contents << self.email_field_tag(method, nil, :class => 'xlarge', :id => 'xlInput')
            contents << self.content_tag(:span, "@", :class => "add-on")
          end
        end
      end

      def show_password_input(method)
        self.show_method_input(method) do
          self.password_field_tag(method, nil, :class => 'xlarge', :id => 'xlInput')
        end
      end

      def show_method_input(method)
        self.contents_tag :div, :class => :clearfix do |contents|
          label_text = self.current_itext(method)
          contents << self.label(method, label_text)
          contents << self.content_tag(:div, :class => :input) do
            yield
          end
        end
      end

      def current_text_group
        self.controller_name.to_s.singularize + '.form'
      end
    end
  end
end
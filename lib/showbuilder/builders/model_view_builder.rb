require 'showbuilder/builders/template_methods'
require 'showbuilder/i18n_text'

module Showbuilder
  module Builders
    class ModelViewBuilder
      include Showbuilder::Builders::TemplateMethods
      include Showbuilder::I18nText

      attr_reader :model

      def initialize(model, template)
        @model      = model
        @template   = template
      end

      def build_model_view(&block)
        unless @model
          return
        end
        self.content_tag(:table, :class => "table table-bordered nohead") do
          @template.capture(self, &block)
        end
      end

      def show_text(*methods)
        self.show_method_field(*methods) do |value|
          self.safe_html_string(value)
        end
      end

      def show_text_link(link_method, text_method)
        methods      = [link_method, text_method]
        method_label = self.show_current_itext(methods)
        method_value = self.call_object_methods(model, methods)
        method_link  = self.call_object_methods(model, link_method)

        self.contents_tag :tr do |contents|
          contents << self.content_tag(:td, method_label.to_s)
          contents << self.content_tag(:td) do
            self.show_model_link_to(method_value.to_s, method_link)
          end
        end
      end

      def show_time(method)
        self.show_method_field(method) do |value|
          self.time_string(value)
        end
      end

      def show_date(method)
        self.show_method_field(method) do |value|
          self.date_string(value)
        end
      end

      def show_currency(method)
        self.show_method_field(method) do |value|
          self.currency_string(value)
        end
      end

      def show_percent(method)
        self.show_method_field(method) do |value|
          self.percent_string(value)
        end
      end

      def show_method_field(*method, &block)
        method_label = self.show_current_itext(method)
        method_value = self.call_object_methods(model, method)
        if block
          method_value = block.call(method_value)
        end

        self.contents_tag :tr do |contents|
          contents << self.content_tag(:td, method_label.to_s)
          contents << self.content_tag(:td, method_value.to_s)
        end
      end

      protected

      def show_current_itext_base
        self.model.class.to_s.underscore
      end
    end
  end
end
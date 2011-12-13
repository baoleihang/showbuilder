require 'view_builder/builders/model_form_builder'

module ViewBuilder
  module ShowModelForm
    
    #
    # show_model_form @customer do |form|
    #   form.show_text_input            :name
    #   form.show_email_input           :email
    #   form.show_password_input        :password
    # end
    #
    # dependents:
    # text_group = @customer.class.to_s.underscore
    # I18n.t("#{text_group}.name")
    # I18n.t("#{text_group}.email")
    # I18n.t("#{text_group}.password")
    #
    def show_model_form(model, options ={}, &block)
      options.merge!(:builder => Viewbuilder::Builders::ModelFormBuilder)
      
      self.html_contents do |contents|
        contents << self.error_messages_for(model) || ""
        contents << self.form_for(model, options) do |form|
          capture(form, &block)
        end
      end
    end

    def error_messages_for(*objects)
      options = objects.extract_options!
      options[:header_message] ||= I18n.t(:"activerecord.errors.header", :default => "Invalid Fields")
      options[:message] ||= I18n.t(:"activerecord.errors.message", :default => "Correct the following errors and try again.")
      messages = objects.compact.map { |o| o.errors.full_messages }.flatten
      if messages.empty?
        return
      end

      contents_tag(:div, :class => "alert-message block-message error") do |contents|
        contents << content_tag(:a, 'x', :class=>'close', :href=>"#")
        contents << content_tag(:p) do
          content_tag(:strong, options[:header_message]) + options[:message]
        end
        contents << content_tag(:ul) do
          list_items = messages.map do |msg|
            content_tag(:li, msg)
          end
          list_items.join.html_safe
        end
      end
      
    end
  end
end
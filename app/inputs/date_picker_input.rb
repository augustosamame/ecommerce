class DatePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_options[:value] ||= object.send(attribute_name)&.strftime('%Y-%m-%d') if object.respond_to?(attribute_name)
    
    template.content_tag(:div, class: 'input-group date', data: { provide: 'datepicker' }) do
      @builder.text_field(attribute_name, input_html_options) +
      template.content_tag(:span, class: 'input-group-addon') do
        template.content_tag(:i, '', class: 'glyphicon glyphicon-calendar')
      end
    end
  end
end
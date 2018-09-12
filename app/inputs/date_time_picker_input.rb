class DateTimePickerInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div, class: 'input-group date form_datetime') do
      template.concat @builder.text_field(attribute_name, input_html_options)
    end
  end

  def input_html_options
    super.merge({class: 'form-control'})
  end

end

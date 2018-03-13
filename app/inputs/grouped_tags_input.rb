#this is an attempt to extend the simple_form category select to support grouped selects
#in simple_form adding <%= f.association :category, as: :grouped_tags, :group_method => :cat_group_for_select, :group_label_method => :cat_group_for_select, :value_method => lambda { |category| "#{category.name}" }, :label_method => lambda { |category| "#{category.name}" }, label: "Categories (you can choose more than one)" %>
#but so far does not work. research on how groupon works needed
class GroupedTagsInput < SimpleForm::Inputs::GroupedCollectionSelectInput
  enable :placeholder

  def input(wrapper_options = {})
    @collection ||= @builder.object.send(attribute_name)
    label_method, value_method = detect_collection_methods

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options.reverse_merge!(multiple: true)

    @builder.collection_select(
      attribute_name, collection, value_method, label_method,
      input_options, merged_input_options
    )
  end
end

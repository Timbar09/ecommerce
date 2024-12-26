module TableHelper
  def specific_attributes(actions)
    show_action = actions.find { |action| action[:name].include?("View") }

    {
      image: ->(item) { link_to image_tag(item.display_thumb_image, class: "table__image radius-md"), show_action[:path].call(item) },
      product_name: ->(item) { item.display_product_name },
      size: ->(item) { item.size.upcase },
      id: ->(item) { item.display_sku },
      price: ->(item) { number_to_currency(item.price) },
      fulfilled: ->(item) { item.display_fulfilled },
      actions: ->(item) {
        render "shared/options_modal" do
          content_tag(:ul, class: "modal__list p-1") do
            actions.map do |action|
              content_tag(:li, class: "modal__list--item") do
                if action[:method] == :delete
                  button_to action[:name], action[:path].call(item), method: :delete, class: "modal__list--link", data_action: "click->options-modal#close"
                else
                  link_to action[:name], action[:path].call(item), method: action[:method], class: "modal__list--link", data_action: "click->options-modal#close"
                end
              end
            end.join.html_safe
          end
        end
      }
    }
  end
end

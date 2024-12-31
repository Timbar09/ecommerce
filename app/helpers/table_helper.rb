module TableHelper
  def header_renderers
    {
      id: controller_name ? "#{controller_name.singularize.titleize} ID" : "ID",
      product_name: "Belongs To",
      fulfilled: "Status"
    }
  end

  def attribute_renderers(actions)
    show_action = actions.find { |action| action[:name].include?("View") }

    {
      image: ->(item) { link_to image_tag(item.display_thumb_image, class: "table__image radius-lg"), show_action[:path].call(item) },
      product_name: ->(item) { item.display_product_name },
      size: ->(item) { item.size.upcase },
      id: ->(item) { link_to item.display_id, show_action[:path].call(item), class: "form__link--primary" },
      price: ->(item) { number_to_currency(item.price) },
      total: ->(item) { number_to_currency(item.total) },
      fulfilled: ->(item) { content_tag(:span, class: item.fulfilled ? "fulfilled flex-inline ai-center gap-1 radius-lg" : "unfulfilled flex-inline ai-center gap-1 radius-lg") do
        icon_html = render "shared/icon", name: item.fulfilled ? "check" : "clock"
        text_html = item.display_fulfilled

        icon_html + text_html
      end
      },
      actions: ->(item) {
        content_tag(:span, class: "table__actions--button", data: { controller: "modal" }) do
          button_html = content_tag(:button, class: "modal__button radius-lg", data: { action: "click->modal#toggle" }) do
            render "shared/icon", name: "ellipsis"
          end

          modal_html = render "shared/modal" do
            content_tag(:ul, class: "modal__list p-1") do
              actions.map do |action|
                content_tag(:li, class: "modal__list--item") do
                  if action[:method] == :delete
                    button_to action[:name], action[:path].call(item), method: :delete, class: "modal__list--link radius-md", data_action: "click->options-modal#close"
                  else
                    link_to action[:name], action[:path].call(item), method: action[:method], class: "modal__list--link radius-md", data_action: "click->options-modal#close"
                  end
                end
              end.join.html_safe
            end
          end

          button_html + modal_html
        end
      }
    }
  end
end

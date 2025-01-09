module TableHelper
  def header_renderers(class_name)
    {
      id: class_name ? "#{class_name.singularize.titleize} ID" : "ID",
      name: class_name == "order" ? "Customer" : "Name",
      created_at: "Order Date",
      product_name: "Belongs To",
      fulfilled: "Status"
    }
  end

  def attribute_renderers(actions)
    show_action = actions.find { |action| action[:name].include?("View") } if actions.any?

    {
      image: ->(item) { link_to image_tag(item.display_thumb_image, class: "table__image radius-lg"), show_action[:path].call(item) },
      product_name: ->(item) { item.display_product_name },
      size: ->(item) { item.size.upcase },
      id: ->(item) { link_to item.display_id, show_action ? show_action[:path].call(item) : "#", class: "link link__primary" },
      price: ->(item) { number_to_currency(item.price) },
      created_at: ->(item) { item.display_order_date },
      total: ->(item) { number_to_currency(item.total) },
      fulfilled: ->(item) { content_tag(:span, class: item.fulfilled ? "fulfilled flex-inline ai-center gap-1 radius-lg" : "unfulfilled flex-inline ai-center gap-1 radius-lg") do
        icon_html = render "shared/icon", name: item.fulfilled ? "check" : "clock"
        text_html = item.display_fulfilled

        icon_html + text_html
      end
      },
      name: ->(item) { item.respond_to?(:display_customer_name) ? content_tag(:span, class: "table__name flex gap-1") do
        img_html = content_tag(:span, class: "table__image--thumb radius-lg") do
          image_tag(item.display_thumb_image, class: "table__image radius-lg")
        end

        span_html = content_tag(:span, class: "flex flex-col") do
          content_tag(:span, item.display_customer_name, class: "table__text--name") +
            if current_page?(admin_orders_path)
              content_tag(:span, item.customer_email.truncate(20), class: "table__text--email")
            else
              content_tag(:span, "#{item.fulfilled ? 'FULFILLED' : 'PENDING'}", class: "table__text--id ml-1", style: "--status-color: #{item.fulfilled ? 'var(--green)' : 'var(--orange)'}")
            end
        end

        img_html + span_html
      end : item.respond_to?(:display_name) ? item.display_name : item.name },
      actions: ->(item) {
        content_tag(:span, class: "table__actions--button", data: { controller: "modal" }) do
          button_html = content_tag(:button, class: "modal__button radius-lg", data: { action: "click->modal#toggle" }) do
            render "shared/icon", name: "ellipsis"
          end

          modal_html = render "shared/modal" do
            content_tag(:ul, class: "modal__list p-1 radius-lg") do
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

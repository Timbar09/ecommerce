class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    puts "=== Stripe webhook endpoint hit ==="
    Rails.logger.info "=== Stripe webhook endpoint hit ==="
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      render json: { error: "Invalid payload" }, status: 400 and return
    rescue Stripe::SignatureVerificationError
      puts "Signature verification failed"
      render json: { error: "Invalid signature" }, status: 400 and return
    end

    case event["type"]
    when "checkout.session.completed"
      session = event["data"]["object"]
      puts "Session New: #{session}"
      handle_checkout_session(session)
    else
      render json: { message: "Unhandled event type: #{event['type']}" }, status: 200 and return
    end

    render json: { message: "Success" }, status: 200
  end

  private

  def handle_checkout_session(session)
    shipping_details = session["shipping_details"]
    if shipping_details
      address = "#{shipping_details['address']['line1']}, #{shipping_details['address']['city']}, #{shipping_details['address']['state']}, #{shipping_details['address']['postal_code']}"
    else
      address = ""
    end

    order = Order.create!(
      customer_email: session["customer_details"]["email"],
      total: session["amount_total"],
      address: address,
      fulfilled: false
    )
    full_session = Stripe::Checkout::Session.retrieve({
      id: session.id,
      expand: [ "line_items" ]
    })
    line_items = full_session.line_items["data"]
    line_items.each do |item|
      product = Stripe::Product.retrieve(item["price"]["product"])
      product_id = product["metadata"]["product_id"].to_i # Double-check this
      OrderProduct.create!(
        order: order,
        product_id: product_id,
        quantity: item["quantity"],
        size: product["metadata"]["size"]
      )
      Stock.find(product["metadata"]["product_stock_id"].to_i).decrement!(:amount, item["quantity"])
    end
  end
end

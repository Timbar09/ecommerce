module ChartHelper
  def process_chart_data(data, options) # hex_color = "#890f9f", gap = 1
    #
    values = data.map { |dataset| dataset[1] }
    highest_value = values.max

    # Round the highest value to the nearest appropriate value upwards
    highest_value_rounded_up = case highest_value
    when 0..10 then (highest_value / 1.0).ceil * 1
    when 11..50 then (highest_value / 5.0).ceil * 5
    when 51..100 then (highest_value / 10.0).ceil * 10
    when 101..500 then (highest_value / 50.0).ceil * 50
    when 501..1000 then (highest_value / 100.0).ceil * 100
    when 1001..5000 then (highest_value / 500.0).ceil * 500
    when 5001..10000 then (highest_value / 1000.0).ceil * 1000
    when 10001..50000 then (highest_value / 5000.0).ceil * 5000
    when 50001..100000 then (highest_value / 10000.0).ceil * 10000
    when 100001..500000 then (highest_value / 50000.0).ceil * 50000
    else (highest_value / 100000.0).ceil * 100000
    end

    # Determine the denominator based on the rounded highest value
    denominator = case highest_value_rounded_up
    when 0..10 then 1
    when 11..25 then 5
    when 26..50 then 10
    when 51..100 then 20
    when 101..500 then 50
    when 501..1_000 then 100
    when 1_001..5_000 then 500
    when 5_001..10_000 then 1_000
    when 10_001..50_000 then 5_000
    when 50_001..100_000 then 10_000
    when 100_001..500_000 then 50_000
    when 500_001..1_000_000 then 100_000
    else 500_000
    end

    x_axis_grid_num = highest_value_rounded_up / denominator

    padding = case highest_value.to_s.size
    when 0 then "1rem"
    when 1..2 then "1.75rem"
    when 3..4 then "2.25rem"
    when 5..6 then "3.25rem"
    else "4rem"
    end

    # Convert hex color to rgba color
    if !options.key?(:hex_color) || options[:hex_color].nil?
      hex_color = "#890f9f"
    elsif options[:hex_color].size == 4
      hex_color = "##{options[:hex_color][1]*2}#{options[:hex_color][2]*2}#{options[:hex_color][3]*2}"
    else
      hex_color = options[:hex_color]
    end

    rgb_color = hex_color.gsub("#", "").scan(/../).map { |color| color.hex }
    rgba_color = "rgba(#{rgb_color.join(', ')}, 0.1)"
    bar_bg_color = "rgba(#{rgb_color.join(', ')}, 0.05)"

    styles = {
      "--padding" => padding
    }

    style_string = styles.map { |key, value| "#{key}: #{value};" }.join(" ")

    max_gap_percentage = 100.0 / values.size

    bar_gap = case options[:gap]
    when 1 then "#{max_gap_percentage * 0.2}%"
    when 2 then "#{max_gap_percentage * 0.4}%"
    when 3 then "#{max_gap_percentage * 0.6}%"
    when 4 then "#{max_gap_percentage * 0.8}%"
    else "#{max_gap_percentage * 0.2}%"
    end

    {
      values: values,
      highest_value_rounded_up: highest_value_rounded_up,
      x_axis_grid_num: x_axis_grid_num,
      padding: padding,
      hex_color: hex_color,
      rgba_color: rgba_color,
      bar_bg_color: bar_bg_color,
      style_string: style_string,
      bar_gap: bar_gap,
      denominator: denominator,
      grid_lines: options[:grid_lines] || false,
      hide_points: options[:hide_points] || false,
      show_area: options[:show_area] || false
    }
  end
end

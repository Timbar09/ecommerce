module ChartHelper
  def process_chart_data(data, options)
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
      hex_color: options[:hex_color] || "#890f9f",
      rgba_color: lighten_color(options[:hex_color] || "#890f9f", 10),
      bar_bg_color: lighten_color(options[:hex_color] || "#890f9f", 5),
      bar_gap: bar_gap,
      pie_size: options[:pie_size] || "50%",
      denominator: denominator,
      grid_lines: options[:grid_lines] || false,
      hide_segments: options[:hide_segments] || false,
      show_area: options[:show_area] || false,
      prefix: options[:prefix] || "",
      short_numbers: options[:short_numbers] || false
    }
  end

  def lighten_color(hex_color, percentage)
    rgb = convert_hex_to_rgb(hex_color)
    "rgba(#{rgb.join(', ')}, #{percentage / 100.0})"
  end

  def convert_hex_to_rgb(hex_color)
    hex_color = if hex_color.size == 4
        "##{hex_color[1]*2}#{hex_color[2]*2}#{hex_color[3]*2}"
    else
        hex_color
    end

    hex_color.gsub("#", "").scan(/../).map { |color| color.hex }
  end

  def shorten_number(number)
    if number >= 1_000_000_000_000
      "#{(number / 1_000_000_000_000.0).round(1)}T"
    elsif number >= 1_000_000_000
      "#{(number / 1_000_000_000.0).round(1)}B"
    elsif number >= 1_000_000
      "#{(number / 1_000_000.0).round(1)}M"
    elsif number >= 1_000
      "#{(number / 1_000.0).round(1)}K"
    else
      number.to_s
    end
  end

  def generate_svg_line_paths(data, chart_data)
    area_path_data = "M"
    line_path_data = "M"
    data.each_with_index do |segment, index|
      x = (index.to_f / (data.size - 1)) * 100
      y = 100 - ((segment[1].to_f / chart_data[:highest_value_rounded_up]) * 100)
      if index == 0
        area_path_data += "#{x},#{y}"
        line_path_data += "#{x},#{y}"
      else
        prev_x = ((index - 1).to_f / (data.size - 1)) * 100
        prev_y = 100 - ((data[index - 1][1].to_f / chart_data[:highest_value_rounded_up]) * 100)
        control_x1 = (prev_x + x) / 2
        control_y1 = prev_y
        control_x2 = (prev_x + x) / 2
        control_y2 = y
        area_path_data += " C #{control_x1},#{control_y1} #{control_x2},#{control_y2} #{x},#{y}"
        line_path_data += " C #{control_x1},#{control_y1} #{control_x2},#{control_y2} #{x},#{y}"
      end
    end

    area_path_data += " L 100,100 L 0,100 Z"

    {
      area_path_data: area_path_data,
      line_path_data: line_path_data
    }
  end

  def generate_pie_chart_paths(data, colors, doughnut)
    total = data.sum { |segment| segment[1] }
    is_one_segment = data.any? { |segment| segment[1] == total }
    angle_offset = 0
    inner_radius = doughnut ? 30 : 0
    paths = data.map.with_index do |segment, index|
      value = segment[1]
      angle = (value.to_f / total) * 360
      large_arc_flag = angle > 180 ? 1 : 0
      outer_x = 50 + 50 * Math.cos((angle_offset + angle) * Math::PI / 180)
      outer_y = 50 + 50 * Math.sin((angle_offset + angle) * Math::PI / 180)
      inner_x = 50 + inner_radius * Math.cos((angle_offset + angle) * Math::PI / 180)
      inner_y = 50 + inner_radius * Math.sin((angle_offset + angle) * Math::PI / 180)
      path_data = if is_one_segment
        if doughnut
          "M 50,50 " \
          "m -50,0 " \
          "a 50,50 0 1,1 100,0 " \
          "a 50,50 0 1,1 -100,0 " \
          "M 50,50 " \
          "m -#{inner_radius},0 " \
          "a #{inner_radius},#{inner_radius} 0 1,0 #{inner_radius * 2},0 " \
          "a #{inner_radius},#{inner_radius} 0 1,0 -#{inner_radius * 2},0"
        else
          "M 50,50 m -50,0 a 50,50 0 1,1 100,0 a 50,50 0 1,1 -100,0"
        end
      else
        "M #{50 + inner_radius * Math.cos(angle_offset * Math::PI / 180)},#{50 + inner_radius * Math.sin(angle_offset * Math::PI / 180)} " \
        "A #{inner_radius},#{inner_radius} 0 #{large_arc_flag},1 #{inner_x},#{inner_y} " \
        "L #{outer_x},#{outer_y} " \
        "A 50,50 0 #{large_arc_flag},0 #{50 + 50 * Math.cos(angle_offset * Math::PI / 180)},#{50 + 50 * Math.sin(angle_offset * Math::PI / 180)} Z"
      end

      # Calculate the midpoint angle for the segment
      mid_angle = angle_offset + angle / 2
      mid_x = 50 + 35 * Math.cos(mid_angle * Math::PI / 180)
      mid_y = 50 + 35 * Math.sin(mid_angle * Math::PI / 180)

      angle_offset += angle

      # Use provided color if available, otherwise generate a random color
      code = colors[index] || "#" + (0..5).map { |i| "0123456789ABCDEF"[rand(16)] }.join

      color = {
        code: code,
        light: lighten_color(code, 80),
        title: segment[0],
        x: mid_x,
        y: mid_y
      }

      { path_data: path_data, color: color, value: value }
    end

    { paths: paths }
  end
end

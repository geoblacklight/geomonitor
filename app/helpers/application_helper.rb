module ApplicationHelper
  def nav_link(link_text, link_path)
    class_name = current_root_path?(link_path) ? 'active' : ''
    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def current_root_path?(link_path)
    if request.path =~ /#{link_path}/
      true
    end

  end

  def status_class(status, content)
    case status
    when 'OK'
      content_tag :span, content, class: 'label label-success'
    when 'FAIL'
      content_tag :span, content, class: 'label label-danger'
    when '??'
      content_tag :span, content, class: 'label label-warning'
    end
  end

  def format_status_num(status)
    html = ""
    puts status
    sorted_status = status.sort_by { |val| val[1].to_i }
    puts sorted_status
    sorted_status.reverse.each do |s|
      html += status_class(s[0], number_with_delimiter(s[1]))
      html += " "
    end
    return html.html_safe
  end

  def format_status_percent(status, total)
    html = ""
    puts status
    sorted_status = status.sort_by { |val| val[1].to_i }
    puts sorted_status
    sorted_status.reverse.each do |s|
      html += status_class(s[0], number_to_percentage((s[1].to_f/total.to_f*100), precision: 1))
      html += " "
    end
    return html.html_safe
  end
end

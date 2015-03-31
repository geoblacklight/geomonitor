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
    sorted_status = status.sort_by { |val| val[1].to_i }
    sorted_status.reverse.each do |s|
      html += status_class(s[0], number_with_delimiter(s[1]))
      html += " "
    end
    return html.html_safe
  end

  def format_status_percent(status, total)
    html = ""
    sorted_status = status.sort_by { |val| val[1].to_i }
    sorted_status.reverse.each do |s|
      html += status_class(s[0], number_to_percentage((s[1].to_f/total.to_f*100), precision: 1))
      html += " "
    end
    return html.html_safe
  end

  def ping_status(status)
    case status
    when true
      content_tag :span, '', class: 'glyphicon glyphicon-ok text-success'
    when false
      content_tag :span, '', class: 'glyphicon glyphicon-remove text-danger'
    end
  end

  def recent_status_badge(status)
    if status[:count] == 0
      status_per = 0
    else
      status_per = status[:ok] / status[:count]
    end
    image_tag "http://img.shields.io/badge/Recent #{status[:count].to_i}-#{number_to_percentage(status_per*100, precision: 1)}-#{percentage_to_color(status_per)}.svg"
  end

  def latest_status_badge(status)
    image_tag "http://img.shields.io/badge/Latest-#{replace_question(status.status)}-#{status_to_color(status.status)}.svg"
  end

  def status_to_color(status)
    case status
    when 'OK'
      return 'brightgreen'
    when '??'
      return 'yellow'
    when 'FAIL'
      return 'red'
    end
  end

  def replace_question(str)
    if str == "??"
      return "%3F%3F"
    else
      return str
    end
  end

  def percentage_to_color(percentage)
    percentage = (percentage * 100).ceil
    case percentage
    when 100
      return 'brightgreen'
    when 0..1
      return 'red'
    when 1..40
      return 'orange'
    when 40..60
      return 'yellow'
    when 60..90
      return 'yellowgreen'
    when 90..100
      return 'green'
    else
      return 'blue'
    end
  end
end

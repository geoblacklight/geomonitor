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

  def status_class(status)
    case status
    when 'OK'
      content_tag :span, 'OK', class: 'label label-success'
    when 'FAIL'
      content_tag :span, 'FAIL', class: 'label label-danger'
    when '??'
      content_tag :span, '??', class: 'label label-warning'
    end
  end
end

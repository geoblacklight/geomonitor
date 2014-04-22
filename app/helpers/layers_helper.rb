module LayersHelper

  def latest_status(layer)
    link_to latest_status_badge(layer.latest_status), layer.latest_status unless layer.latest_status.nil?
  end

  def recent_status(layer)
    recent_status_badge(layer.recent_status) unless layer.recent_status.nil?
  end
end

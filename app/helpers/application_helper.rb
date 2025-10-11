module ApplicationHelper
  def logo(size = "h2")
    link_to(root_path, class: "logo #{size} d-flex align-items-center justify-content-center") do
      content_tag(:i, nil, class: "bi bi-safe2 text-brand")
    end
  end

  def account_page?
    current_page?(edit_user_registration_path)
  end

  def format_time(time)
    time.strftime("%B, %-d %Y - %I:%M %p")
  end

  def render_flash_stream
    turbo_stream.update("flash", partial: "shared/flash")
  end
end

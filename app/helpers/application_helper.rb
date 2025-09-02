module ApplicationHelper
  def logo(size = "h2")
    link_to(root_path, class: "logo #{size}") do
      content_tag(:i, nil, class: "bi bi-safe2 me-2") + "SafePass"
    end
  end

  def account_page?
    current_page?(edit_user_registration_path)
  end

  def format_time(time)
    time.strftime("%m/%d/%Y, %I:%M %p")
  end
end

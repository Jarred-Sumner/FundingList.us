module ApplicationHelper
  def li_for(stuff)
    content_tag(:ul, stuff.map { |string| content_tag(:li, string) }).to_s
  end
end

module ApplicationHelper
  def full_title(page_title)
    base_title = "Флэшкарточкер"
    [base_title, page_title].compact.join(" | ")
  end
end

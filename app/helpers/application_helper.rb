module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def title_header(text)
  	title(text)
  	"<h1>#{text}</h1>"
  end
end

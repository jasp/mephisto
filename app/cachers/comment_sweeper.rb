class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def after_save(record)
    pages = CachedPage.find_by_reference(record.article)
    unless pages.empty?
      controller.class.benchmark "Expired pages referenced by #{record.class} ##{record.id}" do
        pages.each { |p| controller.class.expire_page(p.url) }
        CachedPage.expire_pages(pages)
      end
    end
  end
end
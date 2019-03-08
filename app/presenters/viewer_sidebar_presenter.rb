class ViewerSidebarPresenter < BasePresenter
  def show?
    (num_found != 1 && num_found != 0) || h.params['query']
  end

  def display_num?
    num_found > 3
  end

  # Tells viewer_controller.js which page to load first
  def first_page
    if (!empty?)
      items.first.doc_hash['id']
    else
      parent_id
    end
  end
end
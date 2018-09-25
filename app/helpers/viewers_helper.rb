module ViewersHelper
  def first_child(children, id)
    if (!children.empty?)
      children.items.first.doc_hash['id']
    else
      id
    end
  end
end

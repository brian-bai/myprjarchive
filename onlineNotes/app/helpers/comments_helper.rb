module CommentsHelper
  def note_comments( note_id )
    @comments = Comment.order("created_at DESC").where(["note_id = ? ", note_id])
  end
end

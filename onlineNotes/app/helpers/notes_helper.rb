module NotesHelper
  def recentnotes
     @recent_notes = Note.order("created_at DESC").limit(5).where("openlevel = ?", 1)
     if signed_in?
       @your_recent_notes = Note.order("created_at DESC").limit(3).where("user_id = ?", current_user.id)
     end
  end
end

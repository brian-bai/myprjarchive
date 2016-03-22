class CommentsController < ApplicationController
  before_filter :authenticate, :only => [:create]

  def create
    @comment = Comment.new(params[:comment].merge(:note_id => params[:note_id], 
                                                  :commenter => current_user.name, 
                                                  :user_id => current_user.id))
    if @comment.save
      @comments = Comment.order('created_at DESC').where(["note_id = ?", params[:note_id]])
    end

    respond_to do |format|
      format.html { redirect_to notes_path }
      format.js 
    end
  end
end

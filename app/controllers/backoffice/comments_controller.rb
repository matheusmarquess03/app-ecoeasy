module Backoffice
  class CommentsController < BackofficeController
    before_action :set_evidence, only: [:create]

    def create
      @comment = @evidence.comments.new(comment_params)
      @comment.admin_id = current_admin.id
      @comment.save!

      flash[:success] = 'Comentário salvo com sucesso'
      redirect_back fallback_location: backoffice_path
    rescue StandardError
      flash[:alert] = 'Falha ao savar seu comentário.'
      redirect_back fallback_location: backoffice_path
    end

    def destroy
      @comment = Comment.find(params[:id])
      if @comment.destroy
        flash[:success] = 'Comentário deletado com sucesso'
      else
        flash[:alert] = 'Falha ao deletar seu comentário.'
      end
      redirect_back fallback_location: backoffice_path
    end

    private

    def comment_params
      params.fetch(:comments, {}).permit(:id, :comment)
    end

    def set_evidence
      @evidence = Evidence.find(params[:evidence_id])
    end
  end
end

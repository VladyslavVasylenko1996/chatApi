class Api::V1:: ConversationsController < BaseController

  before_action :find_user, only: [:create]

  def index
    @conversations = current_user.conversations
    render :index
  end

  def create
    current_user_conversation = current_user.conversation_users.pluck(:conversation_id)
    user_conversations = @user.conversation_users.pluck(:conversation_id)
    intersection_array = user_conversations & current_user_conversation
    if intersection_array.length > 0
      # Todo
      # if current_user.conversation_users.find_by(conversation_id: intersection_array[0]).is_deleted
      #   @conversation.add_user current_user
      # else
      #   render json: { errors: 'Conversation exist' }, status: :unprocessable_entity
      # end
    else
      @conversation = current_user.conversations.create
      if @conversation.persisted?
        @conversation.add_user @user
        render :create
      else
        render json: { errors: @conversation.errors.full_messages }, status: :unprocessable_entity
      end
    end

  end


  private

  def find_user
    if params[:conversation] && params[:conversation][:user_id]
      @user = User.find_by(id: params[:conversation][:user_id])
    end
    head (:not_found) unless @user
  end

end

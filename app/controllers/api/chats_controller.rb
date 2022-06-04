class Api::ChatsController < ApplicationController
  before_action :check_valid_app_token
  before_action :set_chat, only: [:show, :update, :destroy]

  # GET /chats
  def index
    chats = Chat.where app_id: app_payload(parameters: chat_params)[:app_id] 
    render json: chats
  end

  # GET /chats/1
  def show
    render json: @chat
  end

  # POST /chats
  def create
    app_id = app_payload(parameters: chat_params)[:app_id]

    chat_num = REDIS.with(timeout: 2.0) do |cache|
      cache.incr "app/#{app_id}/chat_count"
    end
    @chat = Chat.new(num: chat_num, app_id: app_id)

    # save should be requested from consumer of rabbittmq
    return render json: @chat.errors, status: :unprocessable_entity unless @chat.save
    render json: @chat, status: :created, location: api_chat_url(@chat)
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
  end

  private
    def check_valid_app_token
      return render json: { 
        errors: [ "Invalid App-token" ]
        }, status: :unprocessable_entity unless client_has_valid_token?(parameters: chat_params)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by! num: params[:num], app_id: app_payload(parameters: chat_params)[:app_id]
    end
    
    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:app).permit(:token)
    end
end

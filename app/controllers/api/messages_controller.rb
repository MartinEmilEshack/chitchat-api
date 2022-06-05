class Api::MessagesController < ApplicationController
  include RabbitMQ
  include RedisCache

  before_action :check_valid_app_token
  before_action :set_message, only: [:show, :update, :destroy]

  # GET api/apps/chats/1/messages
  def index
    messages = Message.where chat_id: @chat.id
    render json: messages
  end

  # POST api/apps/chats/1/messages
  def create
    message_num = cache.with(timeout: 2.0) do |redis|
      redis.incr "app/#{@chat.app_id}/chat/#{@chat.num}/message_count"
    end

    message = Message.new(num: message_num, chat_id: @chat.id, text: message_params[:text])

    queue.with do |channel|
      exchange = channel.direct('messages', no_declare: true)
      exchange.publish(message.to_json, type: 'create-message')
    end

    render json: message, status: :created
  end

  # PATCH/PUT api/apps/chats/1/messages/1
  def update
    return render json: @message if @message.update(message_params)
    render json: @message.errors, status: :unprocessable_entity
  end

  # DELETE api/apps/chats/1/messages/1
  def destroy
    @message.destroy
  end

  private
    def check_valid_app_token
      return render json: {
        errors: [ "Invalid App-token" ]
      }, status: :unprocessable_entity unless client_has_valid_token?(parameters: message_params)
      @chat = Chat.find_by! num: params[:chat_num], app_id: app_payload(parameters: message_params)[:app_id]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find_by! num: params[:num], chat_id: @chat.id
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:token, :text)
    end
end

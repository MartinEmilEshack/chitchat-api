class Api::V1::MessagesController < ApplicationController
  include RabbitMQ
  include RedisCache

  before_action :check_valid_app_token
  before_action :set_chat, except: :create
  before_action :set_message, only: [ :update, :destroy ]

  # GET api/v1/apps/:app_token/chats/:chat_num/messages
  # GET api/v1/apps/:app_token/chats/:chat_num/messages?search=bla
  def index
    search = params[:search]
    if search
      messages = Message.filtered_search text: search, chat: @chat
    else
      messages = Message.where chat_id: @chat.id
    end

    render json: MessageSerializer.json(messages)
  end

  # POST api/v1/apps/:app_token/chats/:chat_num/messages
  def create
    chat_num = params[:chat_num]

    message_num = cache.with(timeout: 2.0) do |redis|
      redis.incr "app/#{@app_id}/chat/#{chat_num}/message_count"
    end

    message = {
      num: message_num,
      chat_num: chat_num,
      app_id: @app_id,
      text: message_params[:text]
    }

    queue.with do |channel|
      exchange = channel.direct("messages", no_declare: true)
      exchange.publish(message.to_json, type: "create-message")
    end

    render json: {
      num: message_num,
      text: message_params[:text]
    }, status: :created
  end

  # PATCH/PUT api/v1/apps/:app_token/chats/:chat_num/messages/1
  def update
    return render json: MessageSerializer.json(@message) if @message.update(message_params)
    render json: @message.errors, status: :unprocessable_entity
  end

  # DELETE api/v1/apps/:app_token/chats/:chat_num/messages/1
  def destroy
    @message.destroy
  end

  private
    def check_valid_app_token
      app_token = params.require(:app_token)
      @app_id = TokenHelper.decode_token(token: app_token)[:app_id]
    end

    def set_chat
      chat_num = params.require(:chat_num)
      @chat = Chat.find_by! num: chat_num, app_id: @app_id
    end

    def set_message
      message_num = params.require(:num)
      @message = Message.find_by! num: message_num, chat_id: @chat.id
    end

    def message_params
      params.require(:message).permit(:text)
    end
end

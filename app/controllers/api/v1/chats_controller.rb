class Api::V1::ChatsController < ApplicationController
  include RabbitMQ
  include RedisCache

  before_action :check_valid_app_token
  before_action :set_chat, only: [ :show, :destroy ]

  # GET api/v1/apps/:token/chats
  def index
    chats = Chat.where app_id: @app_id
    render json: ChatSerializer.json(chats)
  end

  # GET api/v1/apps/chats/1
  def show
    render json: ChatSerializer.json(@chat)
  end

  # POST api/v1/apps/chats
  def create
    chat_num = cache.with(timeout: 2.0) do |redis|
      count = redis.incr "app/#{@app_id}/chat_count"
      redis.set "app/#{@app_id}/chat/#{count}/message_count", 0
      count
    end

    chat = Chat.new(num: chat_num, app_id: @app_id, message_count: 0)

    queue.with do |channel|
      exchange = channel.direct("chats", no_declare: true)
      exchange.publish(chat.to_json, type: "create-chat")
    end

    render json: ChatSerializer.json(chat), status: :created
  end

  # DELETE api/v1/apps/chats/1
  def destroy
    @chat.destroy
  end

  private
    def check_valid_app_token
      @app_id = TokenHelper.decode_token(token: chat_params)[:app_id]
    end

    def set_chat
      chat_num = params.require(:num)
      @chat = Chat.find_by num: chat_num, app_id: @app_id
    end

    def chat_params
      params.require(:app_token)
    end
end

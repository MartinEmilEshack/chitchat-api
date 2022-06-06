class Api::MessagesController < ApplicationController
  include RabbitMQ
  include RedisCache

  before_action :check_valid_app_token
  before_action :set_chat, except: :create
  before_action :set_message, only: [:show, :update, :destroy]

  # GET api/apps/chats/1/messages
  # GET api/apps/chats/1/messages?search=bla
  def index
    search = params[:search]
    if search
      # localhost TCP error
      messages = MessageRepository.init.search query: { 
        match: { text: search, chat_id: @chat.id, app_id: @chat.app_id }
      }
      messages = messages.each_with_hit do |message, hit|
        { num: message.num, text: message.text, score: hit._score }
      end
    else
      # should be paginated
      messages = Message.where chat_id: @chat.id
    end

    render json: messages
  end

  # POST api/apps/chats/1/messages
  def create
    chat_num = params[:chat_num]
    app_id = app_payload(parameters: message_params)[:app_id]

    message_num = cache.with(timeout: 2.0) do |redis|
      redis.incr "app/#{app_id}/chat/#{chat_num}/message_count"
    end

    message = {
      num: message_num,
      chat_num: chat_num,
      app_id: app_id,
      text: message_params[:text]
    }

    queue.with do |channel|
      exchange = channel.direct('messages', no_declare: true)
      exchange.publish(message.to_json, type: 'create-message')
    end

    render json: {
      num: message_num,
      text: message_params[:text]
    }, status: :created
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
    end

    def set_chat
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

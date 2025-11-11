class Api::V1::AppsController < ApplicationController
  include RedisCache

  before_action :set_app, only: [ :show, :update, :destroy ]

  # GET api/v1/apps
  def index
    apps = App.all
    render json: AppSerializer.json(apps, show_token: true)
  end

  # GET api/v1/apps/:token
  def show
    render json: AppSerializer.json(@app)
  end

  # POST api/v1/apps
  def create
    @app = App.new(app_params(reqToken: false))
    return render json: @app.errors, status: :unprocessable_entity unless @app.save

    cache.with do |redis|
      redis.set "app/#{@app.id}/chat_count", 0
    end

    render json: AppSerializer.json(@app, show_token: true), status: :created
  end

  # PATCH api/v1/apps
  def update
    return render json: AppSerializer.json(@app) if @app.update(app_params(reqToken: false))
    render json: @app.errors, status: :unprocessable_entity
  end

  # DELETE api/v1/apps
  def destroy
    @app.destroy
  end

  private
    def generate_token
      self.token = SecureRandom.hex(10)
    end

    def set_app
      @app = App.find(TokenHelper.decode_token(token: app_params[:token])[:app_id])
    end

    def app_params(reqToken: true)
      if reqToken
        params.require(:token)
        return params.permit(:name, :token)
      end

      app_obj = params.require(:app)
      app_obj.permit(:name)
    end
end

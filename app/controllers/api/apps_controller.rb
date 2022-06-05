class Api::AppsController < ApplicationController
  include RedisCache

  before_action :set_app, only: [:show, :update, :destroy]

  # GET api/apps/:token
  def show
    render json: @app
  end

  # POST api/apps
  def create
    @app = App.new(app_params(reqToken: false))
    return render json: @app.errors, status: :unprocessable_entity unless @app.save

    cache.with do |redis|
      redis.set "app/#{@app.id}/chat_count", 0
    end
    
    @app.token = token(app_id: @app.id, redis_host: "") # redis host should be added to token too
    render json: @app, status: :created
  end

  # PATCH/PUT api/apps/:token
  def update
    return render json: @app if @app.update(app_params(reqToken: false))
    render json: @app.errors, status: :unprocessable_entity 
  end

  # DELETE api/apps/:token
  def destroy
    @app.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      return render json: { 
        errors: [ "Invalid App-token" ]
      }, status: :unprocessable_entity unless client_has_valid_token?(parameters: app_params)
      @app = App.find(app_payload(parameters: app_params)[:app_id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params(reqToken: true)
      app_obj = params.require(:app)
      return app_obj.permit(:name) unless reqToken
      app_obj.permit(:name, :token) 
    end
end

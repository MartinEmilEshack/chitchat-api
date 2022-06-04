class Api::AppsController < ApplicationController
  before_action :set_app, only: [:show, :update, :destroy]

  # GET api/apps/:token
  def show
    render json: @app.to_json(only: [:name, :chat_count])
  end

  # POST api/apps
  def create
    @app = App.new(app_params)
    return render json: @app.errors, status: :unprocessable_entity unless @app.save

    REDIS.with do |cache|
      cache.set "app/#{@app.id}/chat_count", 0
    end
    
    @app.token = token(app_id: @app.id, redis_host: "") # redis host should be added to token too
    render json: @app, status: :created, location: api_app_url(@app)
  end

  # PATCH/PUT api/apps/:token
  def update
    return render json: @app.errors, status: :unprocessable_entity unless @app.update(app_params)

    render json: @app.to_json(only: [:name, :chat_count])
  end

  # DELETE api/apps/:token
  def destroy
    @app.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      return render json: { errors: [ "Incorrect App-token" ] }, status: :unprocessable_entity unless client_has_valid_token?
      @app = App.find(app_payload[:app_id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.require(:app).permit(:name)
    end
end

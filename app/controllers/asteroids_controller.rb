class AsteroidsController < ApplicationController
  before_action :set_asteroid, only: [ :show, :update, :destroy ]

  # GET /asteroids
  def index
    service = AsteroidService.new(Rails.application.credentials.nasa_api_key)
    asteroids = service.fetch_asteroids_from_db

    if asteroids.present?
      render json: asteroids, status: :ok
    else
      render json: { error: "No asteroids found" }, status: :not_found
    end
  end

  # GET /asteroids/:id
  def show
    render json: @asteroid, status: :ok
  end

  # POST /asteroids
  def create
    asteroid = Asteroid.new(asteroid_params)

    if asteroid.save
      render json: asteroid, status: :created
    else
      render json: asteroid.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /asteroids/:id
  def update
    if @asteroid.update(asteroid_params)
      render json: @asteroid, status: :ok
    else
      render json: @asteroid.errors, status: :unprocessable_entity
    end
  end

  # DELETE /asteroids/:id
  def destroy
    @asteroid.destroy
    head :no_content
  end

  def save_from_nasa
    service = AsteroidService.new(Rails.application.credentials.nasa_api_key)
    result, status = service.fetch_and_save_asteroids

    render json: result, status: status
  end

  def save
    service = AsteroidService.new(Rails.application.credentials.nasa_api_key)
    asteroids = params[:asteroids]

    if asteroids.nil? || !asteroids.is_a?(Array)
      return render json: { error: "Invalid data format" }, status: :bad_request
    end

    result, status = service.save_asteroids(asteroids)

    render json: result, status: status
  end

  private

  def set_asteroid
    @asteroid = Asteroid.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Asteroid not found" }, status: :not_found
  end

  def asteroid_params
    params.require(:asteroid).permit(:name, :close_approach_date, :is_potentially_hazardous, :magnitude, :estimated_diameter, :relative_velocity, :nasa_jpl_url)
  end
end

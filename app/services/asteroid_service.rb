class AsteroidService
  include HTTParty
  base_uri 'https://api.nasa.gov'

  def initialize(api_key)
    @api_key = api_key
  end

  # Método para buscar asteroides salvos no banco de dados
  def fetch_asteroids_from_db
    Asteroid.all
  end

  # Método para chamar a API da NASA e salvar asteroides no banco de dados
  def fetch_and_save_asteroids
    options = { query: { api_key: @api_key } }
    response = self.class.get("/neo/rest/v1/feed", options)

    if response.success?
      asteroids_data = response.parsed_response["near_earth_objects"]

      asteroids_data.each do |date, asteroids|
        asteroids.each do |asteroid_data|
          # Verificar se o asteroide já existe antes de criar um novo registro
          existing_asteroid = Asteroid.find_by(nasa_jpl_url: asteroid_data["nasa_jpl_url"])

          unless existing_asteroid
            Asteroid.create(
              name: asteroid_data["name"],
              close_approach_date: asteroid_data["close_approach_data"]&.dig(0, "close_approach_date"),
              is_potentially_hazardous: asteroid_data["is_potentially_hazardous_asteroid"],
              magnitude: asteroid_data["absolute_magnitude_h"].to_f,
              estimated_diameter: asteroid_data.dig("estimated_diameter", "kilometers", "estimated_diameter_max").to_f,
              relative_velocity: asteroid_data.dig("close_approach_data", 0, "relative_velocity", "kilometers_per_hour").to_f,
              nasa_jpl_url: asteroid_data["nasa_jpl_url"]
            )
          end
        end
      end

      return { message: "Asteroids saved successfully" }, :ok
    else
      return { error: "Failed to fetch data from NASA API" }, :bad_request
    end
  end
end

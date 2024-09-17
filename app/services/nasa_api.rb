class NasaApi
  include HTTParty
  base_uri "https://api.nasa.gov"

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_asteroids(start_date, end_date)
    options = { query: { start_date: start_date, end_date: end_date, api_key: @api_key } }
    response = self.class.get("/neo/rest/v1/feed", options)

    # Retorne a resposta da API ou erro se a resposta não for bem-sucedida
    if response.success?
      return response.parsed_response, :ok
    else
      return { error: "Failed to fetch data from NASA API" }, :bad_request
    end
  end
end

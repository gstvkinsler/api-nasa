# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:9000"  # Permite requisições do seu front-end

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ], # Permite os métodos HTTP necessários
      credentials: true # Se precisar enviar cookies ou cabeçalhos de autenticação
  end
end

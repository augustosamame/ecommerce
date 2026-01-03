Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # geocoding service timeout (secs)
  lookup: :google,            # name of geocoding service (symbol)
  ip_lookup: :freegeoip,      # name of IP address geocoding service (symbol)
  language: :es,              # ISO-639 language code
  use_https: true,            # Google requires HTTPS with API key
  api_key: ENV['GOOGLE_GEOCODING_API_KEY'],

  # SSL configuration for development (certificate issues on macOS)
  ssl_options: {
    verify_mode: (Rails.env.development? ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER)
  },

  # Calculation options
  units: :km,                 # :km for kilometers or :mi for miles
  distances: :linear          # :spherical or :linear
)

# frozen_string_literal: true

class Rack::Attack
  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Throttle all requests by IP
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  #
  throttle("req/ip", limit: 600, period: 5.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  # Provided that trusted users use an HTTP request header named APIKey
  # safelist("mark any authenticated access safe") do |req|
  #   req.env["HTTP_RACK_ATTACK_KEY"] == ""
  # end
end

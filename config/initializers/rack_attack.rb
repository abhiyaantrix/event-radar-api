# frozen_string_literal: true

module Rack
  class Attack

    LIMIT_PER_IP = ENV.fetch('RATE_LIMIT_PER_IP', 1_000).to_i

    # Using lambda so we can stub it out in tests
    throttle('req/ip', limit: ->(*) { LIMIT_PER_IP }, period: 1.minute, &:ip)

  end
end

Rack::Attack.throttled_responder = lambda do |request|
  match_data = request.env['rack.attack.match_data']
  now = match_data[:epoch_time]

  headers = {
    'RateLimit-Limit' => match_data[:limit].to_s,
    # Consider adding cache and calculate remaining count on the fly but might cause unnecessary latency
    'RateLimit-Remaining' => '0',
    'RateLimit-Reset' => (now + (match_data[:period] - (now % match_data[:period]))).to_s
  }

  message = 'Throttled'
  response_body = request.env['HTTP_ACCEPT'].eql?('application/json') ? JSON.dump({ message: }) : message

  # TODO: Log or subscribe to this for alerting

  [ 429, headers, [ "#{response_body}\n" ] ]
end

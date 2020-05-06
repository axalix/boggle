if Rails.env.test?
  Redis.current = MockRedis.new
else
  Redis.current = Redis.new(url:  ENV['REDIS_URL'], port: ENV['REDIS_PORT'], db:   ENV['REDIS_DB'])
end


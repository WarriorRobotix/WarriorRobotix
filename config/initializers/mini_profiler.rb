# config/initializers/mini_profiler.rb

if Rails.env.production?
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemcacheStore
end

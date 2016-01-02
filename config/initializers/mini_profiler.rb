# config/initializers/mini_profiler.rb

# If Mini Profiler is included via gem
if Rails.configuration.respond_to?(:load_mini_profiler) && Rails.configuration.load_mini_profiler
  require 'rack-mini-profiler'
  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end

if defined?(Rack::MiniProfiler)
  if Rails.env.production?
    Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemcacheStore
  end
end

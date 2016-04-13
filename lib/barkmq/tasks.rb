namespace :barkmq do
  desc 'Create subscriber queues and subscribe queue to topics'
  task setup: :environment do
    require 'circuitry/provisioning'

    Rails.application.eager_load! if defined?(Rails)

    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO

    Circuitry::Provisioning.provision(logger: logger)
  end

  desc 'BarkMQ subscriber queue worker'
  task :work => [:environment] do |t, args|
    concurrency = ENV['BARKMQ_CONCURRENCY'] || 10
    queues =  ENV['BARKMQ_QUEUES'] || BarkMQ.sub_config.queue_name
    system("bundle exec shoryuken -R -v -c #{concurrency} -q #{queues}")
  end
end

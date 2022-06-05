desc "Run all of your Consumers workers"
task consumers: :environment do
	puts "Starting Consumers"
  Rake::Task["sneakers:run"].invoke
end
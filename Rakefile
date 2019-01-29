# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# Make sure our custom test dirs are run for general test runs
namespace :test do
  task :services => "test:prepare" do
    $: << "test"
    test_files = FileList['test/services/*_test.rb']
    Rails::TestUnit::Runner.run(test_files)
  end
  task :workers => "test:prepare" do
    $: << "test"
    test_files = FileList['test/workers/*_test.rb']
    Rails::TestUnit::Runner.run(test_files)
  end
end

# Tasks
namespace :foreman_orchestration do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanOrchestration'
  Rake::TestTask.new(:foreman_orchestration) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
  end
end

namespace :foreman_orchestration do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_orchestration) do |task|
        task.patterns = ["#{ForemanOrchestration::Engine.root}/app/**/*.rb",
                         "#{ForemanOrchestration::Engine.root}/lib/**/*.rb",
                         "#{ForemanOrchestration::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_orchestration'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:foreman_orchestration'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance do
    Rake::Task['test:foreman_orchestration'].invoke
    Rake::Task['foreman_orchestration:rubocop'].invoke
  end
end

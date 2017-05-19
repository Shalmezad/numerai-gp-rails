namespace :db do
  task :soft_reset => :environment do
    Deme.destroy_all
    Program.destroy_all
    GenerationStat.destroy_all
    Resque.queues.each{|q|Resque.remove_queue(q)}
  end
end

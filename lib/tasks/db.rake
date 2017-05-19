namespace :db do
  task :soft_reset => :environment do
    Deme.destroy_all
    Program.destroy_all
  end
end

namespace :numerai do

  desc "Fetch numerai data"
  task :fetch do
    file = "#{Rails.root}/ext/numerai/data.zip"
    dir = File.dirname(file)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    # Grab the file:
    url = "https://api.numer.ai/competitions/current/dataset"
    # -L is needed to follow redirects...
    command = "curl -L -o #{file} -O #{url}"
    puts "Running: #{command}"
    system command
    # Unip it:
    command = "unzip #{file} -d #{dir}"
    puts "Running: #{command}"
    result = system command
    puts result
  end

  desc "Load numerai data"
  # Going to need the rails environment on this one...
  task :load => :environment do
    #ext/numerai/numerai_training_data.csv
    file = "#{Rails.root}/ext/numerai/numerai_training_data.csv"
    keys = []
    File.foreach(file).with_index do |line, line_num|
      if line_num == 0
        # First line, this is our keys:
        keys = line.chomp.split(",")
        # Need to replace id with n_id
        keys = keys.map{|x|x == "id" ? "n_id" : x}
      else
        # Regular data line.
        data = line.chomp.split(",")
        h = {}
        keys.zip(data){|a,b|h[a.to_sym] = b}
        puts "Creating with: #{h.to_json}"
        TrainingDatum.create(h)
      end # if line_num == 0
    end # File.foreach
  end # task :load

end

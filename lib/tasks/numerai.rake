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
end

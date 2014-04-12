# Loads OGP data into db
require 'json'

namespace :ogp do
  desc "Converts OGP schema data into minimum needed"
  task :convert do
    x = 0
    w = 50
    n = 1
    while n > 0 and x < 100 do
      fn = "data_#{x}_#{x+w}.json"
      json = JSON::parse(File.open(fn).read.to_s)
      json['response']['docs'].each do |doc|
        
      end
      x+=w
    end
  end
end

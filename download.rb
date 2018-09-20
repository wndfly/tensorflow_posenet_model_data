#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

BASE_FILE = 'manifest.json'
DIRS = ['mobilenet_v1_101', 'mobilenet_v1_100', 'mobilenet_v1_075', 'mobilenet_v1_050']
BASE_URL = 'https://storage.googleapis.com/tfjs-models/weights/posenet/'

PROXY = 'http://127.0.0.1:1087'

def fetch_data(url_)
  url = URI(url_)
  proxy = URI(PROXY)
  
  http = Net::HTTP.new(url.host, url.port, proxy.host, proxy.port)

  if url.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  
  http.get(url.path).body
end

def download
  DIRS.each do |item|
    Dir.mkdir item  unless Dir.exists? item

    data = fetch_data "#{ BASE_URL }#{ item }/#{ BASE_FILE }"
    open("#{ item }/#{ BASE_FILE }", 'wb') { |f| f.write data }

    JSON.parse(data).each do |key, value|    
      open("#{ item }/#{ value['filename'] }", 'wb') do |f|
        f.write fetch_data("#{ BASE_URL }#{ item }/#{ value['filename'] }")
      end
    end  
  end
end

if __FILE__ == $0
  download
end



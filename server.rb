#!/usr/bin/env ruby
require 'json'
require 'sinatra'
require_relative 'src/label.class'
require_relative 'src/printer.class'
require_relative 'src/auth.class'

if !File.exists?('config.json') || !File.readable?('config.json')
	raise RuntimeException, 'Could not read config.json'
end

def getLabelFactory(dimensions)
	dimMap = { "12" => [106, 343], "29" => [306, 991], "29x90" => [306, 991], "62" => [696, 1800] }
	if dimMap[dimensions]
		return Label.new(dimMap[dimensions][0], dimMap[dimensions][1], 20)
	else
		raise RuntimeException, 'Unsupported label dimensions'
	end
end

def errorJSON(reason)
	"{\"success\":false,\"statustext\":\"#{reason}\"}"
end

config = JSON.parse(File.read('config.json'))
authenticator = Authenticator.new(config['authKey'])
printer = Printer.new(config['uri'], config['model'], config['dimensions'])
labelFactory = getLabelFactory(config['dimensions'])

get '/' do
	"{\"type\":\"clonestore-printer\", \"name\":\"#{config['name']}\", \"location\":\"#{config['location']}\"}"
end

post '/' do
	if !params['qrdata'] || params['qrdata'] == ''
		return errorJSON('Missing QR data')
	elsif !params['mac'] || params['mac'] == ''
		return errorJSON('Missing request MAC')
	elsif !authenticator.timedAuth(params['qrdata'] + '|' +  params['text'], params['mac'])
		return errorJSON('Invalid request MAC')
	else
		qr = params['qrdata']
		text = params['text']
		id = Digest::MD5.hexdigest(qr+text)
		path = "/tmp/cslbl-#{id}.png"

		begin

			if !File.exists?(path)
				labelFactory.generate(qr, text, path)
			end
			printer.print(path)
			return 	"{\"success\":true,\"statustext\":\"Printing completed\"}"

		rescue PrinterError => e
			return errorJSON("Printer Error: #{e.msg}")
		rescue ImageProcessingError => e
			return errorJSON("Image Processing Error: #{e.msg}")
		end
	end
end
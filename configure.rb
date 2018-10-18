#!/usr/bin/env ruby
require 'fileutils'
require 'json'
require 'securerandom'

uri = '/dev/usb/lp0'
model = 'QL-700'
tapeWidth = '62'

puts "Interactive CloneStore Printer config\n\n"
printerfound = false

while !printerfound do
	puts "Please make sure your Printer is turned on and connected via USB. Press enter to continue."
	gets

	next if !Dir.exists?('/dev/usb')

	puts "Please select the correct USB device (usually lp0)"
	devices = []
	i = 1

	Dir.each_child('/dev/usb'){|file| 
		puts "[#{i}] #{file}"
		devices[i] = file
		i += 1
	}

	selection = gets.chomp.to_i

	if selection < devices.length then
		uri = 'file://' + '/dev/usb/' + devices[selection]
		printerfound = true
	else
		puts "Error: Invalid selection"
	end
end

models = ['QL-500', 'QL-550', 'QL-560', 'QL-570', 'QL-580N', 'QL-650TD', 'QL-700', 'QL-710W', 'QL-720NW', 'QL-800', 'QL-810W', 'QL-820NWB', 'QL-1050', 'QL-1060N']
modelfound = false

while !modelfound do
	puts "Please select your printer model"
	models.each_with_index{|model, i|
		puts "[#{i}] #{model}"
	}

	selection = gets.chomp.to_i

	if selection < models.length then
		model = models[selection]
		modelfound = true
	else
		puts "Error: Invalid selection"
	end
end

widths = ['12', '29', '29x90', '62']
widthfound = false

while !widthfound do
	puts "Please select the label width"
	widths.each_with_index{|width, i|
		puts "[#{i}] #{width}mm"
	}

	selection = gets.chomp.to_i

	if selection < widths.length then
		tapeWidth = widths[selection]
		widthfound = true
	else
		puts "Error: Invalid selection"
	end
end

puts "Print test page? [y/n]"
if(gets.chomp === 'y') then
	system("brother_ql -p #{uri} -m #{model} print -l #{tapeWidth} img/testpage_#{tapeWidth}.png")
end

puts "Generating authentication key..."
authKey = SecureRandom.base64

puts "Saving configuration file..."
config = { "uri" => uri, "model" => model, "tapeWidth" => tapeWidth, "authKey" => authKey }
cfg = File.open('config.json', File::CREAT|File::TRUNC|File::RDWR, 0644)
cfg.write(JSON.dump(config))

puts "\n\n#########################################\n# Please copy this authentication key   #\n# You'll need it to set up the printer  #\n  Key: #{authKey} \n#########################################\n\n"
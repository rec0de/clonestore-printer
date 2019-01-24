require 'shellwords'

class Printer

	@model = nil
	@uri = nil
	@feedDimensions = nil
	@@supportedModels = ['QL-700']
	@@supportedDimensions = ['29x90', '12', '29', '62']

	def initialize(uri, model, dimensions)
		if !@@supportedModels.include?(model)
			raise PrinterError, "Unsupported model #{model}"
		end

		if !@@supportedDimensions.include?(dimensions)
			raise PrinterError, "Unsupported label dimensions #{dimensions}"
		end

		@uri = Shellwords.escape(uri)
		@model = Shellwords.escape(model)
		@feedDimensions = Shellwords.escape(dimensions)
	end

	def print(path, copies = 1)
		plainURI = @uri.gsub('file://', '')
		if !File.exists?(plainURI) || !File.readable?(plainURI)
			raise PrinterError, 'Printer is offline'
		end
		
		escapedPath = Shellwords.escape(path)

		Thread.new {
			copies.times do
				`brother_ql -p #{@uri} -m #{@model} print -l #{@feedDimensions} #{escapedPath} 2>&1`
			end
		}
	end

	def status
		plainURI = @uri.gsub('file://', '')
		File.exists?(plainURI) && File.readable?(plainURI)
	end
end

class PrinterError < RuntimeError
end
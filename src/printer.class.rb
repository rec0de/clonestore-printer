require 'shellwords'

class Printer

	@model = nil
	@uri = nil
	@feedDimensions = nil
	@@supportedModels = ['QL-700']
	@@supportedDimensions = ['29x90']

	def initialize(uri, model, dimensions)
		if !File.exists?(uri) || !File.readable?(uri) then
			raise PrinterError, 'Printer is offline'

		if !@@supportedModels.include?(model)
			raise PrinterError, "Unsupported model #{model}"

		if !@@supportedDimensions.include?(dimensions)
			raise PrinterError, "Unsupported label dimensions #{dimensions}"

		@uri = Shellwords.escape(uri)
		@model = Shellwords.escape(model)
		@feedDimensions = Shellwords.escape(dimensions)
	end

	def print(path)
		escapedPath = Shellwords.escape(path)
		res = `brother_ql -p #{@uri} -m #{@model} print -l #{@feedDimensions} #{escapedPath}`
	end
end

class PrinterError < RuntimeError
end
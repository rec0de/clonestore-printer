require 'rqrcode'
require 'shellwords'

class Label

	def initialize(w, h, padding)
		@width = w
		@height = h
		@padd = padding
		@tmppath = '/tmp/clonestore-qr.png'
	end

	def generate(qr, text, path)
		escaped = Shellwords.escape(text)
		outfile = Shellwords.escape(path)
		qrcode = RQRCode::QRCode.new(qr)
		qrcode.as_png(size: @width, border_modules: 1, file: @tmppath)

		if !File.exists?(@tmppath)
			raise ImageProcessingError, 'QR generation failed'
		end

		magickSuccess = system("convert #{@tmppath} \\( -size #{(@height - @width).to_s}x#{(@width - 2*@padd).to_s} -border 0x#{@padd.to_s} -bordercolor white -background white -fill black -pointsize 40 -font DejaVu-Sans-Book caption:#{escaped} \\) +append -rotate \"90\" #{outfile}")
		if !magickSuccess
			raise ImageProcessingError, 'ImageMagick label creation failed'
		end
	end
end

class ImageProcessingError < RuntimeError
end

require 'rqrcode'
require 'shellwords'

class Label

	@width = 306
	@height = 991
	@padd = 20
	@tmppath = '/tmp/clonestore-qr.png'

	def initialize(w, h, padding)
		@width = w
		@height = h
		@padd = padding
	end

	def generate(qr, text, path)
		escaped = Shellwords.escape(text)
		outfile = Shellwords.escape(path)
		qr = RQRCode::QRCode.new(qr).as_png(size: @width, border_modules: 1)
		IO.write("/tmp/clonestore-qr.png", qrPNG.to_s)
		magickSuccess = system("convert #{@tmppath} \\( -size #{(@height - @width).to_s}x#{(@width - 2*@padd).to_s} -border 0x#{@padd.to_s} -bordercolor white -background white -fill black -pointsize 40 -font DejaVu-Sans-Book caption:#{escaped} \\) +append #{outfile}")
		if !magickSuccess then
			raise RuntimeException, 'ImageMagick label creation failed'
	end
end

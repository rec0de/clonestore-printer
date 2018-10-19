require 'openssl'

class Authenticator

	def initialize(key)
		@key = key
		@digest = OpenSSL::Digest.new('sha256')
	end

	def auth(data, mac)
		computed = OpenSSL::HMAC.hexdigest(@digest, @key, data)
		return self.timesafeEqual(computed, mac)
	end

	def timedAuth(data, mac)
		# Validate mac against 3 possible timestamps (-30s, +0s, +30s) allows for some clock skew between client and server
		# Replay attacks are protected against after 60 seconds
		current = (Time.now().to_i / 30).floor
		return self.auth(data+current.to_s, mac) || self.auth(data+(current-1).to_s, mac) || self.auth(data+(current+1).to_s, mac)
	end

	def timesafeEqual(a, b)
		equal = (a.length === b.length)
		a.each_char.with_index{ |char, i|
			equal = equal & (char === b[i])
		}
		equal
	end
end
require 'net/http'
class Net::HTTP::Purge < Net::HTTPRequest

  METHOD 	= 	'PURGE'
  REQUEST_HAS_BODY 	= 	false
  RESPONSE_HAS_BODY 	= 	true

end
require "net/http"
require "uri"
require "ostruct"
require "json"

class WotRequest
	
	def get_list(nickname)
		uri = URI.parse("http://api.worldoftanks.ru")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new("/wot/account/list/?application_id=demo&search="+nickname)
		response = http.request(request)
		return JSON.parse(response.body)
	end

	def get_info(id)
		uri = URI.parse("http://api.worldoftanks.ru")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new("/wot/account/info/?application_id=demo&account_id="+id.to_s)
		response = http.request(request)
		return JSON.parse(response.body)
	end

end

unless ARGV.length == 1  
  puts
  puts "Usage: ruby wot_info.rb nickname\n"
  exit
end

nickname = ARGV[0]

wr = WotRequest.new

list = wr.get_list(nickname)

for i in 0...list["count"] do
	d = list["data"][i]	
	if d["nickname"] == nickname
		str = d["nickname"]+" "+d["account_id"].to_s
		puts str
		puts
		info = wr.get_info(d["account_id"])
		statistics_all = info["data"][d["account_id"].to_s]["statistics"]["all"]
		puts "battles " + statistics_all["battles"].to_s
		puts "wins " + statistics_all["wins"].to_s
		puts "losses " + statistics_all["losses"].to_s
		p = statistics_all["wins"] * 100.0 / statistics_all["battles"]
		puts "wins percents " + "%.2f" % p + "%"
	end		
end
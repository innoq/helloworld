require 'rubygems'
require 'hpricot'
require 'httpclient'
require 'yaml'

doc = Hpricot(File.open("speaker.html"))

res = []
doc.search(".speaker").each do |speaker|
  s = {}
  speaker.search("h3 a").remove # remove links and other stuff in the headline
  s['company'] = speaker.search("h3 span").remove.inner_html.strip
  s['name'] = speaker.search("h3").inner_html.strip
  s['name'] =~ /((Dr.|Prof.)\s*)*(.+)/
  s['first_name'], s['last_name'] = $3.split(/\s/, 2)
  s['image_url'] = speaker.search("span.pic img").attr('src')
  file_name = File.expand_path(File.join("photos/speaker/", File.basename(s['image_url'])))
  File.open(file_name, "w") do |file|
    file.write HTTPClient.new.get_content(s['image_url'])
  end
  s['file'] = File.join("data/photos/speaker/", File.basename(s['image_url']))
  res << s
end

puts res.to_yaml


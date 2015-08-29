require 'open-uri'

url = 'http://www.languagedaily.com/learn-german/vocabulary/common-german-words/'
html = open(url)
doc = Nokogiri::HTML(html)
rows = doc.xpath('//tr[starts-with(@class, "row")]')

details = rows.collect do |row|
  detail = {}
  [
    [:original_text, 'td[2]/text()'],
    [:translated_text, 'td[3]/text()']
  ].each do |name, xpath|
    detail[name] = row.at_xpath(xpath).to_s.strip
  end
  detail
end

details.each do |item|
  Card.create( original_text: item[:original_text], translated_text: item[:translated_text] )
end
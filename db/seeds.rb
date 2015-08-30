require 'open-uri'

url = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words/"
html = open(url)
doc = Nokogiri::HTML(html)
rows = doc.xpath('//tr[starts-with(@class, "row")]')

rows.map do |row|
  detail = {}
  [
    [:original_text, 'td[2]/text()'],
    [:translated_text, 'td[3]/text()']
  ].each do |name, xpath|
    detail[name] = row.at_xpath(xpath).to_s.strip
    Card.create(original_text: detail[:original_text], translated_text: detail[:translated_text])
  end
  detail
end


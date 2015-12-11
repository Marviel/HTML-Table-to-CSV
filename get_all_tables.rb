require 'nokogiri'
require 'pp'
require 'csv'

html_txt = File.open("index.html", "r").read()

doc = Nokogiri::HTML(html_txt)
nk_rows = doc.xpath('//table[@id="targeted_table"]/tbody/tr')

r = 0
c = 0

#create an array of arrays,
#Form: [[r0c0, r0c1...],[r1c0, r1c1,..],..]
rows = nk_rows.collect do |nk_row|
  nk_cols = nk_row.xpath('td')
  r_arr = nk_cols.collect do |nk_col| 
    t = nk_col.text().strip.gsub(/\n/, ", ")
  end

  r_arr
end

#Output CSV File
CSV.open("data.csv", "wb") do |csv|
  rows.each do |r|
    $stderr.puts r.to_s
    csv << r
  end
end

$stderr.puts "============================="
pp rows
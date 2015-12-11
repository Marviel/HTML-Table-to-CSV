#!/usr/bin/ruby 
#Title: html_table_to_csv.rb
#Author:           Luke Bechtel
#Organization:     independent work    
#Description: Given an html file containing a table with id="targeted_table",
#   Converts the table to a new .csv file.

require 'nokogiri'
require 'pp'
require 'csv'

USAGE="USAGE: ruby html_table_to_csv.rb [input_html_filepath] [output_csv_filepath]"
OUTPUT_FILE_EXISTS="Output File '%s' already exists! Please specify nonexisting file."

#Argument Parsing
if ARGV.count != 2
  $stderr.puts USAGE
  exit(0)
end

infilepath = ARGV[0]
outfilepath = ARGV[1]

if File.exists?(outfilepath)
  $stderr.puts OUTPUT_FILE_EXISTS % (outfilepath)
  exit(0)
end

#################################################################
#Business logic starts here.
#

html_txt = File.open(infilepath, "r").read()

doc = Nokogiri::HTML(html_txt)
nk_rows = doc.xpath('//table[@id="targeted_table"]/tbody/tr')

#Create an array of arrays,
#With elements of each row as the inner arrays.
#Form: [[r0c0, r0c1...],[r1c0, r1c1,..],..]
rows = nk_rows.collect do |nk_row|
  nk_cols = nk_row.xpath('td')
  r_arr = nk_cols.collect do |nk_col| 
    t = nk_col.text().strip.gsub(/\n/, ", ")
  end

  r_arr
end

#Output CSV File
CSV.open(outfilepath, "wb") do |csv|
  rows.each do |r|
    #$stderr.puts r.to_s
    csv << r
  end
end


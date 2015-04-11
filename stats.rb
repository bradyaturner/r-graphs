#!/usr/bin/env ruby

require 'csv'

csv = ""
while STDIN.gets
  csv << $_
end
puts csv

col_data = []

rows = csv.split("\n")

rows.each_with_index do |row,i|
  cd = row.split(",")
  cd.each_with_index do |c,i2|
    col_data[i2] = [] unless col_data[i2]
    col_data[i2] << c
  end
end

col_data.each {|c| puts c.inspect}

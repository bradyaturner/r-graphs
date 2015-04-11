#!/usr/bin/env ruby

require 'csv'

class Table
  attr_reader :titles, :column_data
  def initialize(csv)
    @column_data = []
    rows = csv.split("\n")
    @titles = rows[0].split(",")
    rows[1..-1].each_with_index do |row,i|
      cd = row.split(",")
      cd.each_with_index do |c,i2|
        @column_data[i2] = [] unless @column_data[i2]
        @column_data[i2] << c
      end
    end
  end
end

csv = ""
while STDIN.gets
  csv << $_
end
puts csv

t = Table.new(csv)
puts t.titles.inspect
t.column_data.each {|c| puts c.inspect }

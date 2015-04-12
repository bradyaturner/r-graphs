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
        if c == "nan"
          @column_data[i2] << nil
        else
          @column_data[i2] << c
        end
      end
    end
  end
  def [](r)
    if r.is_a? Integer
      @column_data[r.to_i]
    else
      index = @titles.index(r)
      if !index
        nil
      else
        @column_data[index]
      end
    end
  end
end

def latency_violations(data,ltc_target,phase_target)
  ltc_violations = drops(data)
  d2 = data.select{|d|d}
  d2 = d2.collect { |d| d.to_f }
  d2.each do |d|
    if (d > ltc_target + phase_target) ||
        (d < ltc_target - phase_target)
      ltc_violations += 1
    end
  end
  ltc_violations
end

def drops(data)
  drops = 0
  data.each { |d| drops += 1 if d == nil }
  drops
end

def mean(data)
  d2 = data.select{|d|d}
  sum = 0
  d2.each {|d| sum+=d.to_f}
  sum/d2.length
end

def median(data)
  d2 = data.select{|d|d}
  d2 = d2.collect { |d| d.to_f }
  sorted = d2.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def min(data)
  d2 = data.select{|d|d}
  d2.min_by { |d| d.to_f }
end

def max(data)
  d2 = data.select{|d|d}
  d2.max_by { |d| d.to_f }
end

KEY = "play-hw:0"
LTC_TARGET = 0.000052
PHASE_TARGET = 0.000001
EXCLUDE_COLUMNS = ["timestamp","date","rec-hw:0"]

csv = ""
while STDIN.gets
  csv << $_
end

t = Table.new(csv)

t.titles.each do |title|
  next if EXCLUDE_COLUMNS.include? title
  puts
  puts "Measurement: #{title}"
  puts "Max: %f s" % max(t[title])
  puts "Min: %f s" % min(t[title])
  puts "Median (excluding drops): %f s" % median(t[title])
  puts "Mean (excluding drops): %f s" % mean(t[title])
  puts "Drops: %i" % drops(t[title])

  lv = latency_violations(t[title],LTC_TARGET,PHASE_TARGET)
  tm = t[title].length
  puts "Latency Violations: %i (%.2f)%" % [lv,  (lv.to_f/tm)*100]
  puts "Total measurements: %i" % t[title].length
  puts
end



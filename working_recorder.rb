require 'csv'
require 'Fileutils'
require 'time'
require_relative 'file_path'

class WorkingRecorder
  include FilePath

  def initialize(working_name)
    @current_time = Time.new
    @working_name = working_name
  end

  def record_start_time
    CSV.open(FilePath::INDIVIDUAL_WORKING_PATH, 'w') do |csv|
      csv << %w[working_name working_time]
      csv << [@working_name, @current_time]
    end
  end

  def record_finish_time
    CSV.open(FilePath::INDIVIDUAL_WORKING_PATH, 'a') do |csv|
      csv << ['', @current_time]
    end
  end

  def record_individual_working
    CSV.open(FilePath::ALL_WORKING_PATH, 'a') do |csv|
      csv << %w[working_name working_time] if CSV.read(FilePath::ALL_WORKING_PATH).empty?
      csv << [read_individual_working[:working_name][0],
              calculate_individual_working_time(read_individual_working[:working_time][1],
                                                read_individual_working[:working_time][0])]
    end
  end

  def remove_all_working
    FileUtils.rm_f(FilePath::ALL_WORKING_PATH)
  end

  def remove_individual_working
    FileUtils.rm_f(FilePath::INDIVIDUAL_WORKING_PATH)
  end

  def read_all_working
    CSV.table(FilePath::ALL_WORKING_PATH)
  end

  def calculate_total_working_time(all_working_time)
    all_working_time.inject(0) do |total, working_time|
      total + format_hh_mm_ss_style_to_minutes(working_time)
    end
  end

  def format_all_working_name_and_time(working_name, working_time)
    working_name
      .zip(working_time)
      .map { |name, time| "#{name}(#{format_hh_mm_ss_style_to_minutes(time)}分)" }
      .join("\n")
  end

  private

  def read_individual_working
    CSV.table(FilePath::INDIVIDUAL_WORKING_PATH)
  end

  def calculate_individual_working_time(start_time, finish_time)
    Time.at(Time.parse(start_time) - Time.parse(finish_time)).utc.strftime('%X')
  end

  def format_hh_mm_ss_style_to_minutes(time)
    Time.parse(time).strftime('%H').to_i * 60 + Time.parse(time).strftime('%M').to_i
  end
end

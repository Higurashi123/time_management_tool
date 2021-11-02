require_relative 'exception'
require_relative 'working_recorder'

class TimeManagementTool
  include Exceptions

  def initialize(command_name, working_name)
    @command_name = command_name
    @working_recorder = WorkingRecorder.new(working_name)
  end

  def run
    case @command_name
    when 'start'
      start
    when 'finish_work'
      finish_work
    when 'finish_day'
      finish_day
    end
  end

  def self.usage
    <<~USAGE
      引数に{start 作業のタイトル}で作業の開始時間の打刻をします'
      引数に{finish_work}で作業の終了時間の打刻をします'
      引数に{finish_day}で1日のトータルの作業時間を計算します'
    USAGE
  end

  private

  def start
    raise StateError, '既に作業を開始しています' if individual_working_csv_exist?

    @working_recorder.record_start_time
  end

  def finish_work
    raise StateError, 'まだ作業を開始していません' unless individual_working_csv_exist?

    @working_recorder.record_finish_time
    @working_recorder.record_individual_working
    @working_recorder.remove_individual_working
  end

  def finish_day
    puts <<~TOTAL_WORK
      "#{@working_recorder
        .format_all_working_name_and_time(@working_recorder.read_all_working[:working_name],
                                          @working_recorder.read_all_working[:working_time])}"
      "本日のトータルの作業時間は#{@working_recorder
        .calculate_total_working_time(@working_recorder.read_all_working[:working_time])}分です"
    TOTAL_WORK
    @working_recorder.remove_all_working
  end

  def individual_working_csv_exist?
    File.exist?(FilePath::INDIVIDUAL_WORKING_PATH)
  end
end

if __FILE__ == $PROGRAM_NAME
  usage = TimeManagementTool.usage
  raise Exceptions::CommandError, usage unless %w[start finish_work finish_day].include?(ARGV[0])
  raise Exceptions::CommandError, usage if ARGV[0] == 'start' && ARGV[1].nil?

  time_management_tool = TimeManagementTool.new(ARGV[0], ARGV[1])
  time_management_tool.run
end

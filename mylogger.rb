require 'logger'

=begin
MEMO
it might be better to pass the formatter for own purpose

## usage

$logger = Mylogger.new(STDOUT)
or
$logger = Mylogger.new("foo.log")
$logger.info "info test"

or
module Logging
  def logger
    @logger ||= Mylogger.new(STDOUT)
    # or
    # @logger ||= Mylogger.new("foo.log")
  end
end

include Logging
logger.info "info test"
logger.warn "warn test"
=end

## This class puts out log both in log file and STDOUT
class Mylogger < Logger
  def initialize(logdev, shift_age = 0, shift_size = 1048576, level: DEBUG,
                 progname: nil, formatter: nil, datetime_format: nil,
                 shift_period_suffix: '%Y%m%d')

    unless formatter
      # https://stackoverflow.com/a/34026278
      # formatter https://docs.ruby-lang.org/ja/latest/class/Logger=3a=3aFormatter.html
      formatter = proc do |severity,time,progname,msg|

        nseverity = severity.ljust(5," ")

        # ansi color: https://qiita.com/PruneMazui/items/8a023347772620025ad6#%E5%87%BA%E5%8A%9B%E8%89%B2%E3%81%AE%E5%A4%89%E6%9B%B4
        # \e[30m : character color black
        # \e[43m : background clolor yellow
        # \e[0m  : reset ansi escape sequence set before
        # for stdout
        if severity == "ERROR" || severity == "WARN"
          # for stdout in case of log file
          puts "#{time.strftime('%Y-%m-%d %H:%M:%S.%3N')} [\e[30m\e[43m#{nseverity}\e[0m] : #{msg}" if logdev.class == String
          # for log file
          "#{time.strftime('%Y-%m-%d %H:%M:%S.%3N')} [\e[30m\e[43m#{nseverity}\e[0m] : #{msg}\n" # need \n
        else
          # for stdout in case of log file
          puts "#{time.strftime('%Y-%m-%d %H:%M:%S.%3N')} [#{nseverity}] : #{msg}" if logdev.class == String
          # for log file
          "#{time.strftime('%Y-%m-%d %H:%M:%S.%3N')} [#{nseverity}] : #{msg}\n" # need \n
        end
      end
    end

    super(logdev, shift_age = 0, shift_size = 1048576, level: DEBUG,
                 progname: nil, formatter: formatter, datetime_format: nil,
                 shift_period_suffix: '%Y%m%d')
  end
end


## This class puts out log both STDOUT and YYMMDD_HHMMSS.log
class Mylogger < Logger
  def initialize(logfile = nil ,datetime_prefix = nil)
    logdev = logfile ? logfile : STDOUT
    formatter = proc do |severity, datetime, progname, msg|
      ## "#{datetime} [#{severity}] #{progname} #{msg}\n"

      ## loft adjustment severity
      # https://stackoverflow.com/questions/6407141/how-can-i-have-ruby-logger-log-output-to-stdout-as-well-as-file/34026278#34026278
      nseverity = severity.ljust(5," ")

      ## for logfile
      # puts must be executed before formatter definition
      # ansi color: https://qiita.com/PruneMazui/items/8a023347772620025ad6#%E5%87%BA%E5%8A%9B%E8%89%B2%E3%81%AE%E5%A4%89%E6%9B%B4
      # \e[30m : character color black
      # \e[43m : background clolor yellow
      # \e[0m  : reset ansi escape sequence set before
      if logfile
        if datetime_prefix
          if severity == "ERROR" || severity == "WARN"
            puts "#{datetime.strftime('%Y-%m-%d %H:%M:%S.%3N')} [\e[30m\e[43m#{nseverity}\e[0m] : #{msg}\n"
          else
            puts "#{datetime.strftime('%Y-%m-%d %H:%M:%S.%3N')} [#{nseverity}] : #{msg}\n"
          end
        else
          puts "#{msg}"
        end
      end

      # for formatter
      if date_time_prefix
        ## formatter and for logfile
        # https://docs.ruby-lang.org/ja/latest/class/Logger.html#I_FORMATTER--3D
        # *return value should be STRING of call method*
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S.%3N')} [#{nseverity}] : #{msg}\n"
      else
        puts "#{msg}"
      end
    end

    super(logdev,formatter: formatter)
  end
end

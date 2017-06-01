module Logging
  class MailgunWebhook

    def initialize
      if File.exists?(log_path)
        @log_file = File.open(log_path, 'a')
      else
        @log_file = File.new(log_path, 'w')
        @log_file.puts('Email, IP, Subject, Type')
      end
    end

    def log(record)
      @log_file.puts("#{record[:email]}, #{record[:ip]}, #{record[:subject]}, #{record[:type]}")
    end

    def close
      @log_file.close
    end

    private

    def log_path
      "#{Rails.root}/tmp/logs.csv"
    end

  end
end
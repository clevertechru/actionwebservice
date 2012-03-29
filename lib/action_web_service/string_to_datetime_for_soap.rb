# encoding: UTF-8
module StringToDatetimeForSoap
  def to_datetime
    begin
      if /^([+\-]?\d{4,})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d(?:\.(\d*))?)(Z|(?:[+\-]\d\d:\d\d)?)?$/ =~ self.strip
        return Time.xmlschema(self).localtime
      end
      super
    rescue
      # If a invalid date is supplied, it will automatically turn it into the first Julian Day
      # Jan/01 - 4712 BC - This is a simple solution, until a better one appear :)
      return Date.new
    end
  end
end

String.send :include, StringToDatetimeForSoap

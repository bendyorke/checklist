require 'time'
require 'date'

class Task
  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR   = SECONDS_IN_MINUTE * 60
  SECONDS_IN_DAY    = SECONDS_IN_HOUR   * 24

  def initialize **params
    @attrs = defaults.merge(params)
  end

  def [] key
    @attrs.fetch(key, "")
  end

  def []= key, value
    @attrs[key] = value
  end

  def to_row headers = @attrs.keys
    headers.map(&:to_sym).inject({}) do |memo, key|
      memo[key] = self[key] and memo
    end
  end

  def status
    return :due     if due?
    return :overdue if overdue?
    return :completed
  end

  def complete!
    self[:date_completed] = DateTime.now.to_s and self
  end

  def time
    DateTime.parse(self[:time] + now.zone)
  end

  def to_s
    "%-10s%-20s%-20s - %s" %[
      self[:time],
      self[:name][0..20],
      date_completed.strftime('%m.%d.%Y at %I:%M %p'),
      status
    ]
  end

  private
  def defaults
    { date_completed: DateTime.now }
  end

  def now
    DateTime.now
  end

  def date_completed
    DateTime.parse(self[:date_completed])
  end

  def reminder_time
    window = ENV['checklist_window'] || SECONDS_IN_HOUR    
    time - window.to_f/SECONDS_IN_DAY
  end

  def due?
    completed_yesterday? && in_notification_window?
  end

  def overdue?
    !completed_yesterday? && !completed_today?
  end

  def completed_yesterday?
    date_completed > (reminder_time - 1) && date_completed < reminder_time
  end

  def completed_today?
    date_completed > reminder_time
  end

  def in_notification_window?
    now > reminder_time && now <= time
  end
end


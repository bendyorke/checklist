# Ruby libraries
require 'rspec'
require 'csv'
require 'date'

# Check libraries 
require_relative '../lib/task.rb'
require_relative '../lib/list.rb'

# Contexts
shared_context "tasks with status" do
  let(:time)           { Time.now + 1200 }
  let(:formatted_time) { time.strftime("%I:%M %p") }
  let(:completed_task) { Task.new(name: "completed task", time: formatted_time, date_completed: (DateTime.parse("#{time} #{time.zone}") + 0.5).to_s) }
  let(:due_task)       { Task.new(name: "due task",       time: formatted_time, date_completed: (DateTime.parse("#{time} #{time.zone}") - 0.5).to_s) }
  let(:overdue_task)   { Task.new(name: "overdue task",   time: formatted_time, date_completed: (DateTime.parse("#{time} #{time.zone}") - 1.5).to_s) }
  let(:task) { [completed_task, due_task, overdue_task].sample }
end

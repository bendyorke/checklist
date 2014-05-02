require 'csv'
require_relative 'task.rb'

class List
	attr_reader :data
	HEADER_VALUES = ["name", "time", "date_completed"]

	def initialize path
		@path = path
		create_data unless File.exists? path
		load_data
	end

	def add_task task
    @data << task
    save_data 
	end

  def remove_task name
    @data.reject! { |task| task[:name] == name }
    save_data
  end

  def complete_task name
    @data.map! { |task| task[:name] == name ? task.complete! : task }
    save_data
  end

  def count
    @data.inject(0) do |memo, task|
      task.status != :completed ? memo += 1 : memo
    end
  end

  def priority
    statuses = @data.map(&:status).uniq
    return :overdue if statuses.include? :overdue
    return :due if statuses.include? :due
  end

	private

	def load_data 
		@data = CSV.open(@path, headers: true, header_converters: :symbol)
               .to_a
               .map { |row| Task.new(row) }
	end

	def save_data 
		CSV.open(@path, "w") do |csv|
			csv << HEADER_VALUES
      @data.each { |task| csv << task.to_row(HEADER_VALUES).values }
		end
	end

	def create_data 	
		CSV.open(@path, "wb") { |csv| csv << HEADER_VALUES }
	end
end

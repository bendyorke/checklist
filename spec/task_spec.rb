require_relative 'spec_helper.rb'
describe Task do
  include_context "tasks with status"
  describe '#initialize' do
    it "correctly creates getters for all attributes" do
      expect(task[:name]).to include "task"
    end

    it "correctly creates setters for all attributes" do
      task[:name] = "wash car"
      expect(task[:name]).to eq "wash car"
    end

    it "has a default for date_completed" do
      expect(Task.new(name: "fix sink")[:date_completed].class).to eq DateTime
    end
  end

  describe '#to_row' do
    it "outputs a hash with all values if no headers specified" do
      expect( task.to_row.keys.length ).to eq 3
    end

    it "outputs a hash with the given headers" do
      expect( task.to_row(["name"]) ).to eq task.to_row.select { |k,v| k == :name }
    end

    it "uses an empty string if no value is found" do
      expect( task.to_row(["country"]).values ).to eq [""]
    end

    it "returns only the values asked for in the order they were requested" do
      expect( task.to_row(["country", "name"]).keys ).to eq [:country, :name]
    end
  end   

  describe '#status' do
    it "recognizes a :due task" do
      expect( due_task.status ).to eq :due
    end

    it "recognizes a :completed task" do
      expect( completed_task.status ).to eq :completed
    end

    it "recognizes an :overdue task" do
      expect( overdue_task.status ).to eq :overdue
    end
  end

  describe '#complete!' do
    it "updates the date_completed for the task" do
      expect(overdue_task.complete!.status).to eq :completed
    end
  end
end

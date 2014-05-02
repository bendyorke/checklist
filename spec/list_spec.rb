require_relative 'spec_helper.rb'
describe List do
  include_context "tasks with status"
  let(:checklist) { Dir.pwd + '/test_checklist.csv' }
  let(:list)      { List.new(checklist) }
  let(:task1)     { completed_task }
  let(:task2)     { due_task }
  let(:task3)     { overdue_task }

  before do
    unless example.metadata[:skip_initialization]
      File.delete(checklist) if File.exists?(checklist)
      list.add_task task1
      list.add_task task2
    end
  end

  describe '#initialize' do
    context "when the database does not exist", skip_initialization: true do
      before do
        File.delete(checklist) if File.exists?(checklist)
      end

      it "creates the file if it doesn't exist" do
        list 
        expect(File.exists?(checklist)).to eq true
      end
    end

    context "when the database is present" do
      before do
        list.add_task task1
        list.add_task task2
      end

      it "loads data from the csv" do
        expect(list.data.map { |task| task[:name] }).to include task1[:name]
      end
    end
  end


  describe '#add_task' do
    before do
      list.add_task task3
    end

    it "adds task to data object" do
      expect(list.data.map { |task| task[:name] }).to include task3[:name]
    end

    it "writes task to the csv" do
      names = CSV.open(checklist, headers: true, header_converters: :symbol)
                 .map { |row| row[:name] }

      expect(names).to include task3[:name]
    end
  end

  describe '#remove_task' do
    before do
      list.remove_task task1[:name]
    end

    it "removes a task from the data object" do
      expect(list.data.map { |task| task[:name] }).not_to include task1[:name]
    end

    it "removes task from csv" do
      names = CSV.open(checklist, headers: true, header_converters: :symbol)
                 .map { |row| row[:name] }

      expect(names).not_to include task1[:name]
    end
  end

  describe '#complete_task' do
    before do
      list.complete_task due_task[:name]
    end

    it "completes a task" do
      expect(list.count).to eq 0
    end
  end 

  describe '#count' do
    it "counts the number of due and overdue tasks" do
      expect(list.count).to eq 1
      list.add_task task3
      expect(list.count).to eq 2
    end
  end

  describe "#priority" do
    it "returns nil if there is no tasks" do
      list.remove_task due_task[:name]
      expect(list.priority).to eq nil
    end

    it "returns :due if there is a due task, but no overdue task" do
      expect(list.priority).to eq :due
    end

    it "returns :overdue if there is an overdue task" do
      list.add_task overdue_task
      expect(list.priority).to eq :overdue
    end
  end
end


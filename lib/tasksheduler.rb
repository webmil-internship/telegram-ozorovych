# create array of tags from Task model instances
# chose one task
# return it
class Tasksheduler
  def create
    Task.each do |task|
      tag = task[:tag]
      puts tag
      puts Date.today
      Schedule.create[tag: tag, date: Date.today]
    end
  end
end

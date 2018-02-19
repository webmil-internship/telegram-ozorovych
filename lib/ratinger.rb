# Select all records of current day
# Sort records by confidence
# Build list
class Ratinger
  def today
    todays_task = Schedule.find(date: Date.today)
    todays_task.nil?
    if todays_task.nil?
      puts 'no task for today'
    else
      puts todays_task.id
      puts Rating.find(task_id: todays_task.id)
    end
  end
end

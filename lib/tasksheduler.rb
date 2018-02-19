class Tasksheduler
  def description
    create.description
  end

  def tag
    create.tag
  end

  def id
    create.id
  end

  private

  def create
    todays = Schedule.find(date: Date.today)
    if Schedule.find(date: Date.today).nil?
    puts 'current_tag is empty'
    # Function to add task to schedule and return error message to user
    else
      Task.find(tag: todays.tag)
    end
  end
end

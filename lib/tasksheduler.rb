class Tasksheduler
  def description
    if create.nil?
      'No task for today'
    else
      create.description
    end
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
    nil
    # Raise error
    # Function to add task to schedule and return message to user
    else
      current_task = Task.find(tag: todays.tag)
    end
  end
end

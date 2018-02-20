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
    'current_tag is empty'
    # Raise error
    # Function to add task to schedule and return message to user
    else
      current_task = Task.find(tag: todays.tag)
    end
  end
end

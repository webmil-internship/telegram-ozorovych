class Ratinger
  def show
    todays_tag = Schedule.find(date: Date.today)
    if todays_tag.nil?
      'No rating for today yet'
    else
      n = 0
      todays_task = Task.find(tag: todays_tag.tag)
      rating = Rating.where(task_id: todays_task.id).order(:propability).reverse
      new_rating = rating.map do |rate|
        user = User.find(id: rate.user_id)
        n += 1
        "#{n}: #{user.user_name} - #{rate.propability}"
      end
      new_rating.join("\n")
    end
  end
end

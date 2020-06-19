categories = ['home', 'work', 'other']
categories.each do |title|
  category = Project.create!(title: "#{title} tasks")
  5.times do |n|
    category.todos.create!(text: "#{title} task №#{n + 1}",
                           isCompleted: [true, false].sample)
  end
end

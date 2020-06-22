class TodosController < ApplicationController
  skip_forgery_protection

  def create
    if todo_params[:project_id] && (@todo = Todo.create(todo_params))
      render json: @todo, status: :created
    elsif project_params[:new_project_title].present? &&
          (@todo = Project.where(title: project_params[:new_project_title])
                             .first_or_create.todos.create(todo_params))
      render json: @todo, status: :created
    else
      render_standard_error
    end
  end

  def update
    if (@todo = Todo.find_by(id: params[:id], project_id: params[:project_id]))
      @todo.toggle(:isCompleted)
      @todo.save
      render json: @todo, status: :ok
    else
      render_standard_error
    end
  end

  private

  def render_standard_error
    render json: { message: 'You did something wrong' }, status: :unprocessable_entity
  end

  def todo_params
    params.require(:todo).permit(:text, :isCompleted, :project_id)
  end

  def project_params
    params.require(:todo).permit(:new_project_title)
  end
end

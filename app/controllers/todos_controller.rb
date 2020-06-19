class TodosController < ApplicationController
  skip_forgery_protection
  def create
    if project_params[:is_new_project] === 'true' && !Project.exists?(title:project_params[:new_project_title])
      @new_project = Project.create(title: project_params[:new_project_title])
      @object = @new_project.todos.create(todo_params)
      render json: @object, status: :created
    elsif Project.exists?(todo_params[:project_id])
      @object = Todo.create(todo_params)
      render json: @object, status: :created
    else
      render json: { message: 'You did something wrong' }, status: :unprocessable_entity
    end
  end

  def update
    if Project.exists?(params[:project_id]) && Project.find(params[:project_id]).todos.exists?(params[:id])
      @todo = Todo.find(params[:id])
      @todo.isCompleted = !@todo.isCompleted
      @todo.save
      render json: { state: @todo.isCompleted }, status: :ok
    else 
      render json: { message: 'You did something wrong' }, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:text, :isCompleted, :project_id)
  end

  def project_params
    params.require(:todo).permit(:project_id, :is_new_project, :new_project_title)
  end
end

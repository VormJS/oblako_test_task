class ProjectsController < ApplicationController
  def index
    projects = Project.all
    render json: projects, include: ['todos']
  end
end

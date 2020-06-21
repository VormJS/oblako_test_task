class ProjectsController < ApplicationController
  skip_forgery_protection
  def index
    projects = Project.all
    render json: projects, include: ['todos']
  end
end

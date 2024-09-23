class TasksController < AuthenticatedController
  include ProjectScoped
  include TasksHelper

  skip_before_action :set_project, if: -> { params[:project_id].blank? }
  skip_before_action :set_nodes, if: -> { params[:project_id].blank? }

  def index
    @default_columns = ['Title', 'Methodology', 'Due Date', 'Assigned']

    if current_project
      @local_storage_key = "project.ce.project_#{current_project.id}.tasks_datatable"
      @tasks = assigned_cards(current_project.id)
    end
  end

  private

  # ProjectScoped always calls current_project. We are overwriting it here to
  # prevent errors in Pro when viewing tasks outside of projects.
  def current_project
    return if params[:project_id].blank?

    super
  end
end

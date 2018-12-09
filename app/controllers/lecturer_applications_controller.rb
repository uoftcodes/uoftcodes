# frozen_string_literal: true

class LecturerApplicationsController < ApplicationController
  before_action :authorize_only_member!, only: %i[new create]

  def new
    @lecturer_application = LecturerApplication.new
  end

  def create
    resume_upload = params[:lecturer_application][:resume]

    unless resume_upload.content_type == 'application/pdf'
      flash.now[:alert] = 'Please upload a PDF'
      render :new
      return
    end

    @lecturer_application = LecturerApplication.new(lecturer_application_params)
    @lecturer_application.resume = Base64.encode64(resume_upload.read)
    @lecturer_application.user = current_user

    if @lecturer_application.save
      flash[:info] = 'Event successfully created.'
      redirect_to lecturer_application_path(@lecturer_application)
    else
      flash.now[:alert] = @lecturer_application.build_error_message
      render :new
    end
  end

  def show
    @lecturer_application = LecturerApplication.find_by_id(params[:id])

    @lecturer_application = nil if current_user.lecturer? && @lecturer_application.user != current_user

    raise ActionController::RoutingError, 'Not Found' if @lecturer_application.nil?
  end

  private

  def lecturer_application_params
    params.require(:lecturer_application).permit(:interests, :additional_info)
  end

  def authorize_only_member!
    return if current_user.member?

    flash.now[:info] = 'You are already a lecturer.'
    redirect_to root_path
  end
end

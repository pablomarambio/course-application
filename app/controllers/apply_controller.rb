class ApplyController < ApplicationController

  before_filter :authenticate_user!

  def block
    #find batch
    @batch = current_user.course_batch
    #find block
    if params[:block]
      @block = Block.find(params[:block])
      #check if block closed
      # flash[:alert] = "Block is closed." unless @block.open_status
    else
      @block = @course_batch.blocks.first
    end

    @applications = current_user.applications_for_block(@block)

    unless (@block == @batch.blocks.last) && (@batch.blocks.count > 1)
      @next_block = @batch.blocks[@batch.blocks.index(@block)+1]
    end

  end

  def up
    #block & batch & apps
    block = Block.find(params[:block])
    batch = current_user.course_batch
    applications = current_user.applications_for_block(block)
    #move application up
    application1 = Application.find(params[:application])
    application2 = applications[applications.index(application1) - 1]
    current_user.switch_applications(application1, application2)
    redirect_to apply_path(batch.id, block.id)
  end

  def down
    #block & batch & apps
    block = Block.find(params[:block])
    batch = current_user.course_batch
    applications = current_user.applications_for_block(block)
    #move application up
    application1 = Application.find(params[:application])
    application2 = applications[applications.index(application1) + 1]
    current_user.switch_applications(application1, application2)
    redirect_to apply_path(batch.id, block.id)
  end

  def summary
  end

end

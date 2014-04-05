class DevicesController < ApplicationController
  # GET /devices.json
  def index
    render json: Device.all
  end

  # GET /devices/:id.json
  def show
    render json: Device.find(params[:id])
  end
end

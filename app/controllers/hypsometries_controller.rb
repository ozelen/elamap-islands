class HypsometriesController < ApplicationController
  # GET /hypsometries
  # GET /hypsometries.json
  def index
    @hypsometries = Hypsometry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hypsometries }
    end
  end

  # GET /hypsometries/1
  # GET /hypsometries/1.json
  def show
    @hypsometry = Hypsometry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hypsometry }
    end
  end

  # GET /hypsometries/new
  # GET /hypsometries/new.json
  def new
    @hypsometry = Hypsometry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hypsometry }
    end
  end

  # GET /hypsometries/1/edit
  def edit
    @hypsometry = Hypsometry.find(params[:id])
  end

  # POST /hypsometries
  # POST /hypsometries.json
  def create
    @hypsometry = Hypsometry.new(params[:hypsometry])

    respond_to do |format|
      if @hypsometry.save
        format.html { redirect_to @hypsometry, notice: 'Hypsometry was successfully created.' }
        format.json { render json: @hypsometry, status: :created, location: @hypsometry }
      else
        format.html { render action: "new" }
        format.json { render json: @hypsometry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hypsometries/1
  # PUT /hypsometries/1.json
  def update
    @hypsometry = Hypsometry.find(params[:id])

    respond_to do |format|
      if @hypsometry.update_attributes(params[:hypsometry])
        format.html { redirect_to @hypsometry, notice: 'Hypsometry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hypsometry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hypsometries/1
  # DELETE /hypsometries/1.json
  def destroy
    @hypsometry = Hypsometry.find(params[:id])
    @hypsometry.destroy

    respond_to do |format|
      format.html { redirect_to hypsometries_url }
      format.json { head :no_content }
    end
  end
end

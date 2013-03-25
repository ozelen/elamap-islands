class IslandsController < ApplicationController
  # GET /islands
  # GET /islands.json
  def index
    @islands = Island.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @islands }
    end
  end

  # GET /islands/1
  # GET /islands/1.json
  def show
    @island = Island.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @island }
    end
  end

  # GET /islands/new
  # GET /islands/new.json
  def new
    @island = Island.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @island }
    end
  end

  # GET /islands/1/edit
  def edit
    @island = Island.find(params[:id])
  end

  # POST /islands
  # POST /islands.json
  def create
    @island = Island.new(params[:island])

    respond_to do |format|
      if @island.save
        format.html { redirect_to @island, notice: 'Island was successfully created.' }
        format.json { render json: @island, status: :created, location: @island }
      else
        format.html { render action: "new" }
        format.json { render json: @island.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /islands/1
  # PUT /islands/1.json
  def update
    @island = Island.find(params[:id])

    respond_to do |format|
      if @island.update_attributes(params[:island])
        format.html { redirect_to @island, notice: 'Island was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @island.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /islands/1
  # DELETE /islands/1.json
  def destroy
    @island = Island.find(params[:id])
    @island.destroy

    respond_to do |format|
      format.html { redirect_to islands_url }
      format.json { head :no_content }
    end
  end
end

require 'base64'
class SessionsController < ApplicationController
  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = Session.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sessions }
    end
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
    @session = Session.find(params[:id])
    lessons = 0
    @session.units.each { |unit| unit.texts.each { |text| lessons+=text.lessons if text.lessons } if unit.texts } if @session.units
    @session['lessons'] = lessons
    filename = 'public/images/upload/session_' + @session.id.to_s + '.png'
    @session['img'] = File.exist?(filename) ? filename : nil

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        render json: @session.to_json(
            :include => {
              :units => {
                  :include => :texts
              }
            }
        )
      }

      # format.json { render json: @unit.to_json(:include => :texts) }
    end
  end

  # GET /sessions/new
  # GET /sessions/new.json
  def new
    @session = Session.new
    @students = Student.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @session }
    end
  end

  # GET /sessions/1/edit
  def edit
    @session = Session.find(params[:id])
    @students = Student.all
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = Session.new(params[:session])

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render json: @session, status: :created, location: @session }
      else
        format.html { render action: "new" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sessions/1
  # PUT /sessions/1.json
  def update
    @session = Session.find(params[:id])

    respond_to do |format|
      if @session.update_attributes(params[:session])
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session = Session.find(params[:id])
    @session.destroy

    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { head :no_content }
    end
  end

  def structure
    @session = Session.find(params[:session_id])
    @units = Unit.scoped_by_session_id(params[:session_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @units }
    end
  end

  def upload
    @session = Session.find(params[:session_id])
    @image = params[:data]
    directory = "public/images/upload"
    path = File.join(directory, "session_"+@session.id.to_s+".png")
    File.open(path, "wb") { |f| f.write(Base64.decode64(@image)) }
    flash[:notice] = "File uploaded"

    respond_to do |format|
      format.js
    end
  end

end

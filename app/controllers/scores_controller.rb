class ScoresController < ApplicationController
  # GET /scores
  # GET /scores.json
  def index
    @scores = Score.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scores }
    end
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
    @score = Score.find(params[:id])
    @student = @score.student

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @score }
      format.js
    end
  end

  # GET /scores/new
  # GET /scores/new.json
  def new
    @score = Score.new
    @score.student_id ||= params[:student_id]
    teacher = Teacher.find_by_user_id(current_user.id)
    @score.teacher_id = teacher.id if teacher
    @score.text_id = params[:text_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @score }
      format.js
    end
  end

  # GET /scores/1/edit
  def edit
    @score = Score.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @score}
      format.js
    end
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(params[:score])
    @student = @score.student

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: 'Score was successfully created.' }
        format.json { render json: @score, status: :created, location: @score }
      else
        format.html { render action: "new" }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
      format.js {render action: 'show'}

    end
  end

  # PUT /scores/1
  # PUT /scores/1.json
  def update
    @score = Score.find(params[:id])
    @student = @score.student

    respond_to do |format|
      if @score.update_attributes(params[:score])
        format.html { redirect_to @score, notice: 'Score was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
      format.js {render action: 'show'}
    end
  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    @score = Score.find(params[:id])
    @score.destroy

    respond_to do |format|
      format.html { redirect_to scores_url }
      format.json { head :no_content }
    end
  end
end

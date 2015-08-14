class RegistrationFieldsController < ApplicationController
  before_action :set_registration_field, only: [:edit, :update, :destroy, :up, :down]

  def new
    @registration_field = RegistrationField.new
  end

  def edit
  end

  def create
    @registration_field = RegistrationField.new(registration_field_params)

    respond_to do |format|
      if @registration_field.save
        format.html { redirect_to registration_fields_url, notice: 'Registration field was successfully created.' }
        format.json { render :show, status: :created, location: @registration_field }
      else
        format.html { render :new }
        format.json { render json: @registration_field.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registration_field.update(registration_field_params)
        format.html { redirect_to registration_fields_url, notice: 'Registration field was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration_field }
      else
        format.html { render :edit }
        format.json { render json: @registration_field.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration_field.destroy
    respond_to do |format|
      format.html { redirect_to registration_fields_url, notice: 'Registration field was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render :update_table }
    end
  end

  def fix
    RegistrationField.create([{ title: "First name" }, { title: "Last name" }, { title: "Email" }, { title: "Grade" }])
    respond_to do |format|
      format.html { redirect_to registration_fields_url, notice: 'Registration fields\' issues were successfully fixed.' }
      format.js { render :update_table }
    end
  end

  def up
    RegistrationField.where(order: @registration_field.order - 1).update_all('"order" = "order" + 1')
    @registration_field.order -= 1
    @registration_field.save

    respond_to do |format|
      format.html { redirect_to registration_fields_url }
      format.json { head :no_content }
      format.js { render :update_rows }
    end
  end

  def down
    RegistrationField.where(order: @registration_field.order + 1).update_all('"order" = "order" - 1')
    @registration_field.order += 1
    @registration_field.save

    respond_to do |format|
      format.html { redirect_to registration_fields_url }
      format.json { head :no_content }
      format.js {render :update_rows}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_field
      @registration_field = RegistrationField.find(params[:registration_field_id], params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_field_params
      params.require(:registration_field).permit(:title, :input_type, :options, :optional)
    end
end
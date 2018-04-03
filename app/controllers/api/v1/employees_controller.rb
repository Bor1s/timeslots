class Api::V1::EmployeesController < ApplicationController
  def index
    employees = Employee.all
    render json: employees
  end

  def show
    employee = Employee.find(params[:id])
    render json: employee
  end

  def create
    employee = Employee.new(employees_params)
    if employee.save
      render json: employee
    else
      render json: { errors: employee.errors.full_messages }, status: 422
    end
  end

  def update
    employee = Employee.find(params[:id])
    if employee.update_attributes(employees_params)
      render json: employee
    else
      render json: { errors: employee.errors.full_messages }, status: 422
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy
    head :ok
  end

  private

  def employees_params
    params.require(:employee).permit(:email, :name)
  end
end

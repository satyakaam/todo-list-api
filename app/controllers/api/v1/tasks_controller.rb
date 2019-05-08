module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:update, :show, :destroy]

      def index
        render json: Task.all, include: [:tags]
      end

      def create
        task = Task.new(task_params)

        if task.save
          render json: task,
                  status: :created,
                  include: [:tags]
        else
          render json: task,
                  status: :unprocessable_entity,
                  serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        if @task.update(task_params)
          render json: @task, include: [:tags]
        else
          render json: @task,
                  status: :unprocessable_entity,
                  serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def show
        render json: @task, include: [:tags]
      end

      def destroy
        @task.destroy
        render json: {message: 'Successfully deleted'}
      end

      private

      def task_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:title, :tags])
      end

      def set_task
        @task = Task.find(params[:id])
      end
    end
  end
end

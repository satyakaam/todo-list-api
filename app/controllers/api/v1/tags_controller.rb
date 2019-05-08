module Api
  module V1
    class TagsController < ApplicationController
      before_action :set_tag, only: [:update, :show, :destroy]

      def index
        render json: Tag.all, include: :tasks
      end

      def create
        tag = Tag.new(tag_params)

        if tag.save
          render json: tag,
                  status: :created,
                  include: :tasks
        else
          render json: tag,
                  status: :unprocessable_entity,
                  serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        if @tag.update(tag_params)
          render json: @tag,
                  status: :ok,
                  include: :tasks
        else
          render json: @tag,
                  status: :unprocessable_entity,
                  serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def show
        render json: @tag, include: :tasks
      end

      def destroy
        @tag.destroy
        render json: {message: 'Successfully deleted'}
      end

      private

      def tag_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:title])
      end

      def set_tag
        @tag = Tag.find(params[:id])
      end
    end
  end
end

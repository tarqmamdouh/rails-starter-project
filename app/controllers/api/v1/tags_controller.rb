module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      def index
        render json: Tag.all, status: :ok
      end
    end
  end
end

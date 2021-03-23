module Api
  module V1
    class AnswersController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, only: :create
      before_action :authorized_owner, only: %i[update destroy]

      def index
        info = {
          page: params[:page] || 1,
          per_page: params[:per_page] || 5
        }
        answers = question.answers.paginate(page: info[:page], per_page: info[:per_page])
        render json: answers, status: :ok, params: info, meta: pagination_dict(answers)
      end

      def show
        if answer.present?
          render json: answer, status: :ok
        else
          render json: {}, status: :not_found
        end
      end

      def create
        @answer = Answer.new(answer_params)
        if @answer.save
          render json: @answer, status: :ok
        else
          render json: {}, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        @answer = Answer.find_by(id: params[:id])
        if @answer.update(answer_params)
          render json: @answer, status: :ok
        else
          render json: @answer, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        Answer.find_by(id: params[:id]).destroy
        render json: {}, status: :no_content
      end

      private

      def answer_params
        params.require(:data).require(:attributes).permit(:body, :question_id).merge(
          user_id: current_user.id,
          question_id: params.dig(:data, :relationships, :question, :data, :id)
        )
      end

      def question
        QuestionFinder.run(params[:slug])
      end

      def answer
        Answer.find_by_id(params[:id])
      end

      def authorized_owner
        if current_user.present?
          current_user.questions.include?(question)
        else
          render json: {}, status: :unauthorized
        end
      end
    end
  end
end

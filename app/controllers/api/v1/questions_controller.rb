module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, only: :create
      before_action :authorize_owner, only: %i[update destroy]

      def index
        info = {
          page: params[:page] || 1,
          per_page: params[:per_page] || 5
        }
        questions = Question.paginate(page: info[:page], per_page: info[:per_page])
        render json: questions, status: :ok, params: info, meta: pagination_dict(questions)
      end

      def create
        @question = Question.new(question_params)
        if @question.save
          render json: @question, status: :ok
        else
          render json: {}, status: :unprocessable_entity, error: error_message
        end
      end

      def show
        @question = question
        if @question.present?
          render json: @question, status: :ok
        else
          render json: {}, status: :not_found
        end
      end

      def tagged_with
        filtered_questions = Question.all_tagged_with(params[:tags])
        render json: filtered_questions, status: :ok
      end

      def update
        if question.update(question_params)
          render json: question, status: :ok
        else
          render json: {}, status: :unprocessable_entity, error: error_message
        end
      end

      def destroy
        question.destroy
        render json: {}, status: :no_content
      end

      private

      def question_params
        params.require(:data).require(:attributes).permit(:title, :description, :tags_string).merge(user_id: cureent_user.id)
      end

      def question
        QuestionFinder.run(params[:id])
      end

      def authorize_owner
        current_user.questions.include?(question)
      end

      def error_message
        question.errors.full_messages.to_sentence
      end
    end
  end
end

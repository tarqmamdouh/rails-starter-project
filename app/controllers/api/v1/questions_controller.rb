module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, only: :create
      before_action :authorized_owner, only: %i[update destroy]

      def index
        if query_tagged?
          tagged_questions
        else
          paginated_questions
        end
      end

      def create
        @question = Question.new(question_params)
        if @question.save
          render json: @question, status: :ok
        else
          render json: @question, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def show
        if question.present?
          render json: question, status: :ok
        else
          render json: {}, status: :not_found
        end
      end

      def update
        @question = Question.find_by(id: params[:id])
        if @question.update(question_params)
          render json: @question, status: :ok
        else
          render json: @question, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        Question.find_by(id: params[:id]).destroy
        render json: {}, status: :no_content
      end

      private

      def query_tagged?
        params[:tags].present?
      end

      def tagged_questions
        tags_list = params[:tags].split(',')
        questions = Question.all_tagged_with(tags_list)
        render json: questions, status: :ok
      end

      def paginated_questions
        info = {
          page: params[:page] || 1,
          per_page: params[:per_page] || 5
        }
        questions = Question.paginate(page: info[:page], per_page: info[:per_page])
        render json: questions, status: :ok, params: info, meta: pagination_dict(questions)
      end

      def question_params
        params.require(:data).require(:attributes).permit(:title, :description, :tagsstring).merge(user_id: current_user.id)
      end

      def question
        QuestionFinder.run(params[:id])
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

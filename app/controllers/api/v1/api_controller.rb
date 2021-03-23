module Api::V1
  class ApiController < ApplicationController
    def index
      render text: "API"
    end

    private

    def pagination_dict(object)
      {
        current_page: object.current_page,
        next_page: object.next_page,
        prev_page: object.previous_page,
        total_pages: object.total_pages,
        total_count: object.total_entries
      }
    end

    def current_account_user
      @current_account_user ||=
        AccountUser.new(user: current_user, account: current_account)
    end

    def current_account
      @current_account ||=
        current_user.accounts.find_by_id(request.headers['X-accountId']) ||
        current_user.accounts.first
    end

    def current_user
      @current_user ||=
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Pagy::Backend

  private

  def pagination_meta(pagy)
    {
      pages: pagy.pages,
      current_page: pagy.page,
    }
  end
end

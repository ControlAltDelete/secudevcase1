class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  def index
    @post = Post.new
    @posts = Post.paginate(:page => params[:page])
  end

  def search
    @posts = Post.find_substring(params[:content])
    if @posts
      flash[:success] = "Search results for #{params[:content]}"
    else
      flash[:danger] = "No results found for #{params[:content]}"
    end
  end

  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    redirect_to root_url
    flash[:danger] = "Unauthorized access. Try again."
  end
  private

    def post_params
      params.require(:post).permit(:content)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end

class HomeController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def index
  end

  def posts
  end
end

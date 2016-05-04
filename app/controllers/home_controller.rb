class HomeController < ApplicationController
  def home
    @tournaments = Tournament.all
  end
end

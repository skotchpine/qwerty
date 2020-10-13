class InfoController < ApplicationController
  before_action :authenticate_user!, only: %i[users]

  def anyone; end

  def users; end
end

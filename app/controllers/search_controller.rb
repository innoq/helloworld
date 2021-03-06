class SearchController < ApplicationController
  respond_to :html, :json

  skip_before_filter :check_login, :only => [:search]

  def search
    if params[:q].presence
      words = params[:q].split(/[\s,]/).select{|w| w.present?}.map{|w| "%#{w}%"}
      id_sets = []
      words.each do |word|
        id_sets << Profile.search(word)
      end

      ids = nil
      id_sets.each do |set|
        ids = ids ? ids & set : set
      end

      @results = Profile.where(:id => ids).paginate(:page => params[:page],
        :per_page => 10,
        :order => 'last_name, first_name')
    end
  end

end
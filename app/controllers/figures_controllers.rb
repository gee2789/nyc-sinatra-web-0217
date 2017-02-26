require "rack-flash"

class FiguresController < ApplicationController
  use Rack::Flash

  get '/figures' do
    @figures = Figure.all
    # binding.pry
    erb :'figures/index'
  end

  post '/figures' do
    @figures = Figure.create(params["figure"])
    #saves the figure and associates checked ids
    #params["figures"] passes in
    #figure[name]
    #figure[title_ids][] -  maps to the table figure_titles.
    #figure[landmark_ids][] - how does this map?  I don't have landmark_ids column on any tables.

    if !params["landmark"]["name"].empty? #checks to see if landmark form is empty
      @figures.landmarks << Landmark.create(params["landmark"]) #pulls the landmark params.
    end

    if !params["title"]["name"].empty?
      @figures.titles << Title.create(params["title"])
      # @figures.landmarks = Landmark.find_or_create_by(params["landmark"])
      # @figures.title = Title.find_or_createby(params["title"])

      #create new genre & associate with new figure
      #take selected existing genres and associated with new figure
      @figures.save
      # binding.pry
      redirect "/figures/#{@figures.id}"
    end
  end

  get '/figures/new' do
    erb :'figures/new'
  end

  get '/figures/:id' do
    @figures = Figure.find(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    @figures = Figure.find(params[:id])
    erb :'figures/edit'
  end

  patch '/figures/:id' do
    @figures = Figure.find(params[:id])
    @figures.update(params[:figure])

    if !params["landmark"]["name"].empty?
      @figures.landmarks << Landmark.create(params["landmark"])
    end

    if !params["title"]["name"].empty?
      @figures.titles << Title.create(params["titles"])
    end
    @figures.save
    redirect "/figures/#{@figures.id}"
  end
end

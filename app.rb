class Game

  attr_reader :last_winner, :computer_pick



  PAIRS = {
    dropshot:     { beats: :backhand },
    backhand:    { beats: :forehand },
    forehand: { beats: :dropshot }
  }.freeze

  def initialize()
    @player1 = Player.new 'Human'
    @computer = Player.new 'Computer'
  end

  def winner
    return nil if same_pick?

    if PAIRS[@player1.pick][:beats] == @computer.pick
      @player1
    else
      @computer
    end
  end

  def play(pick)
    @computer_pick = PAIRS.keys.sample
    @player1.picks pick and @computer.picks @computer_pick
    if winner != nil
      @last_winner = "#{winner.name}"
    else
      @last_winner = 'Draw'
    end
  end

  private

  def same_pick?
    @player1.pick == @computer.pick
  end

end



class Player

  attr_reader :pick, :name

  def initialize(name)
    @name = name
  end

  def picks(pick)
    @pick = pick
  end

end


require 'sinatra'
require 'securerandom'

class TennisMatch < Sinatra::Base
  enable :sessions
  
  @@games = Hash.new

  get '/' do
    if !@@games.has_key?(session[:id])
      session[:id] = SecureRandom.uuid
      @@games[session[:id]] = Game.new
    end

    redirect '/index.html'
  end

  # get '/index.html' do
  #   redirect '/'
  # end

  post '/game/:pick' do
    @@games[session[:id]].play(params[:pick].to_sym)
  end


  get '/game' do
    #"Draw"
#    @@games[session[:id]].play(:backhand)
    "#{@@games[session[:id]].last_winner}"
  end

  get '/computer_pick' do
     "#{@@games[session[:id]].computer_pick}"
  end


end
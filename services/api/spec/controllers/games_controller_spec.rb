# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:id) { 'dCseRLF6kOzNK83OdUzMXw' }
  let(:serialized_game) { {
      'id' => id,
      'dice_type' => 'classic_16',
      'board_size' => '4',
      'game_length_secs' => '100',
      'dice_string' => 'applepearorangex',
      'started_at' => Time.now,
      'stopped_at' => nil
  } }

  let(:expected_game_data) {
    {
        'board' => { 'size' => 4, 'dice_string' => a_kind_of(String) },
        'dice' => { 'dice_chars' => 'aaciotabiltyabjmoqacdempacelrsadenvzahmorsbiforxdenoswdknotueefhiyegkluyegintvehinpselpstugilruw', 'dice_count' => 16 },
        'seconds_left' => a_kind_of(Numeric),
        'words' => []
    }
  }

  let(:started_game) { Boggle::Game.restore(id) }

  before {
    Redis.current.mapped_hmset("boggle:game:#{id}", serialized_game)
    allow(StringHelper).to receive(:real_word?).and_return true
  }


  describe 'game token is not sent' do
    context '#create' do
      it 'returns status 200' do
        post :create
        expect_good_response response
      end

      it 'returns data in a correct format' do
        get :create
        game_data = JSON.parse(response.body)
        expect(game_data['id']).to be_a_kind_of(String)
        expect(game_data).to include expected_game_data
      end
    end

    context '#show' do
      it 'returns status 422 / :unprocessable_entity' do
        get :show
        expect_missing_token_response response
      end
    end

    context '#add_word' do
      it 'returns status 422 / :unprocessable_entity' do
        post :add_word, params: { word: 'apple' }
        expect_missing_token_response response
      end
    end

    context '#get_results' do
      it 'returns status 422 / :unprocessable_entity' do
        get :get_results
        expect_missing_token_response response
      end
    end
  end

  describe 'game token is sent' do
    before { request.headers['Game-Token'] = started_game.id }

    context '#show' do
      it 'returns status 200' do
        get :show
        expect_good_response response
      end

      it 'returns data in a correct format' do
        get :show
        expect(JSON.parse(response.body)).to include expected_game_data
      end
    end

    context '#add_word' do
      it 'returns status 200' do
        post :add_word, params: { word: 'apple' }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/plain; charset=utf-8'
      end

      it 'returns status 422 and an error about a short word' do
        post :add_word, params: { word: '' }
        expect_error_response(response, '{"message":"param is missing or the value is empty: word"}')
      end

      it 'returns status 422 and an error about the game is over' do
        started_game.stop!
        post :add_word, params: { word: 'apple' }
        expect_error_response(response, '{"message":"The game is over"}')
      end
    end

    context '#get_results' do
      it 'returns status 200' do
        get :get_results
        expect_good_response response
      end

      it 'returns data in a correct format' do
        get :get_results

        game_data = JSON.parse(response.body)
        expect(game_data['results']).to eq({'total_score' => 0, 'words_with_scores' => []})
        expect(game_data).to include expected_game_data.without('words')
      end

      it 'returns "data" with zero seconds left when results are requested' do
        get :get_results
        expect(JSON.parse(response.body)['seconds_left']).to eq 0
      end

    end
  end

  #-------------------------------------------

  private def expect_good_response(response)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq 'application/json; charset=utf-8'
  end

  private def expect_missing_token_response(response)
    expect_error_response(response, '{"message":"Boggle::Errors::MissingToken"}')
  end

  private def expect_error_response(response, message)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to eq message
  end
end

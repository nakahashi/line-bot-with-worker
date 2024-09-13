require 'rspec'
require 'rack/test'
require_relative '../app'

RSpec.describe App do
  include Rack::Test::Methods

  def app
    App
  end

  describe "POST /callback" do
    context "正当な署名によるリクエストだった場合" do
      let(:valid_signature) { 'valid_signature' } # テスト用に仮の署名を用意
      let(:body) { { events: [] }.to_json } # 仮のリクエストボディ

      before do
        header 'X-Line-Signature', valid_signature # モックした署名をリクエストヘッダに設定
        post '/callback', body, { "CONTENT_TYPE" => "application/json" }
      end

      it 'OKを返す' do
        expect(last_response).to be_ok
        expect(last_response.body).to eq('OK')
      end
    end

    context "不正な署名によるリクエストだった場合" do
      before do
        allow_any_instance_of(Line::Bot::Client).to receive(:validate_signature).and_return(false)
        header 'X-Line-Signature', 'invalid_signature'
        post '/callback', {}.to_json, { "CONTENT_TYPE" => "application/json" }
      end

      it '400を返す' do
        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Bad Request')
      end
    end
  end
end

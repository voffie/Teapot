# frozen_string_literal: true

require 'teapot/resource_manager'
require 'fileutils'

RSpec.describe ResourceManager do
  include ResourceManager

  before do
    FileUtils.mkdir_p('./public')
    File.write('./public/test.png', 'image_data')
    File.write('./public/styles.css', 'body { background: #fff; }')
    File.write('./public/script.js', 'console.log("test");')
  end

  after do
    FileUtils.rm_rf('./public')
  end

  describe '#load_img' do
    context 'when the image file exists' do
      it 'returns the image data and content type' do
        result = load_img('/test.png')
        expect(result[:status]).to eq(200)
        expect(result[:file]).to eq('image_data')
        expect(result[:size]).to eq(10)
        expect(result[:ct]).to eq('image/png')
      end
    end

    context 'when the image file does not exist' do
      it 'returns a 404 status' do
        result = load_img('/missing.png')
        expect(result[:status]).to eq(404)
      end
    end
  end

  describe '#load_script' do
    context 'when the script file exists' do
      it 'returns the script content' do
        result = load_script('/script.js')
        expect(result[:status]).to eq(200)
        expect(result[:file]).to eq('console.log("test");')
      end
    end

    context 'when the script file does not exist' do
      it 'returns a 404 status' do
        allow(File).to receive(:exist?).with('./public/missing.js').and_return(false)

        result = load_script('/missing.js')
        expect(result[:status]).to eq(404)
      end
    end
  end

  describe '#css' do
    context 'when the CSS file exists' do
      it 'returns the CSS content' do
        allow(File).to receive(:exist?).with('./public/styles.css').and_return(true)
        allow(File).to receive(:read).with('./public/styles.css').and_return('body { background: #fff; }')

        result = css('/styles.css')
        expect(result[:status]).to eq(200)
        expect(result[:file]).to eq('body { background: #fff; }')
      end
    end

    context 'when the CSS file does not exist' do
      it 'returns a 404 status' do
        allow(File).to receive(:exist?).with('./public/missing.css').and_return(false)

        result = css('/missing.css')
        expect(result[:status]).to eq(404)
      end
    end
  end
end

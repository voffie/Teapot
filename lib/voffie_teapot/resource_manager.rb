# frozen_string_literal: true

require 'slim'

IMG_CONTENT_TYPES = {
  apng: 'image/apng', avif: 'image/avif', gif: 'image/gif',
  jpg: 'image/jpeg', jpeg: 'image/jpeg', jfif: 'image/jpeg',
  pjpeg: 'image/jpeg', pjp: 'image/jpeg', png: 'image/png',
  svg: 'image/svg+xml', webp: 'image/webp'
}.freeze

module VoffieTeapot
  # Module to handle loading/generating resources
  module ResourceManager
    def load_slim(resource, locals = {}, layout: true)
      content = read_file("./views/#{resource}.slim")
      layout_content = layout ? read_file('./views/layout.slim') : nil

      rendered = Slim::Template.new { content }.render(nil, locals)
      layout ? Slim::Template.new { layout_content }.render { rendered } : rendered
    rescue StandardError => e
      "Error rendering template #{e.message}"
    end

    def css(resource)
      load_public_file(resource, 'text/css')
    end

    def load_img(resource)
      load_public_file(resource, IMG_CONTENT_TYPES[resource.split('.').last.to_sym])
    end

    def load_script(resource)
      load_public_file(resource, '*/*')
    end

    private

    def load_public_file(resource, content_type)
      normalized_resource = resource.start_with?('/') ? resource[1..] : resource
      path = "./public/#{normalized_resource}"
      if File.file?(path)
        { file: File.read(path), ct: content_type, status: 200, size: File.size(path) }
      else
        { status: 404 }
      end
    end

    def read_file(path)
      File.read(path)
    rescue Errno::ENOENT
      raise "File not found #{path}"
    end
  end
end

# frozen_string_literal: true

require 'slim'

IMG_CONTENT_TYPES = {
  apng: 'image/apng',
  avif: 'image/avif',
  gif: 'image/gif',
  jpg: 'image/jpeg',
  jpeg: 'image/jpeg',
  jfif: 'image/jpeg',
  pjpeg: 'image/jpeg',
  pjp: 'image/jpeg',
  png: 'image/png',
  svg: 'image/svg+xml',
  webp: 'image/webp'
}

module ResourceManager
  def load_slim(resource, layout = true, locals = {})
    contents = File.binread("./views/#{resource}.slim")
    if layout
      current_layout = File.binread('./views/layout.slim')
      l = Slim::Template.new { current_layout }
      c = Slim::Template.new { contents }.render(nil, locals)
      l.render { c }
    else
      c = Slim::Template.new { contents }.render(self, locals)
    end
    rescue Errno::ENOENT
      p "Can not locate #{resource}"
      nil
    end
  end

  def css(resource)
    file = File.read("./public/#{resource}")
    { content: file, status: 200 }
    rescue Errno::ENOENT
      p 'CSS-file not found!'
      { content: '', status: 404 }
    end
  end

  def load_img(resource)
    image = File.binread("./public#{resource}")
    ct = IMG_CONTENT_TYPES[resource.split('.')[-1]]
    { ct: ct, file: image, size: File.size("./public#{resource}"), status: 200 }
    rescue Errno::ENOENT
      p 'File can not be located!'
      { file: '', status: 404 }
    end
  end

  def load_script(resource)
    file = File.read("./public/#{resource}")
    { content: file, status: 200 }
    rescue Errno::ENOENT
      p 'Script file cannot be located'
      { content: '', status: 404 }
    end
  end
end

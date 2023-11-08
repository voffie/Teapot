require 'slim'

IMG_CONTENT_TYPES = {'apng': 'image/apng',
  'avif': 'image/avif',
  'gif': 'image/gif',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'jfif': 'image/jpeg',
  'pjpeg': 'image/jpeg',
  'pjp': 'image/jpeg',
  'png': 'image/png',
  'svg': 'image/svg+xml',
  'webp': 'image/webp'
}

module ResourceManager
  def load_slim(resource, layout = true, locals = {})
    begin
      contents = File.open("./views/#{resource}.slim", 'rb').read
      if layout
        currentLayout = File.open('./views/layout.slim', 'rb').read
        l = Slim::Template.new { currentLayout }
        c = Slim::Template.new { contents }.render(nil, locals)
        l.render { c }
      else
        c = Slim::Template.new {contents}.render(self, locals)
      end
    rescue Errno::ENOENT
      p "Can not locate #{resource}"
      return nil
    end
  end

  def css(resource)
    begin
      file = File.open("./public/#{resource}").read
      {content: file, status: 200}
    rescue Errno::ENOENT
      p 'CSS-file not found!'
      {content: '', status: 404}
    end
  end

  def load_img(resource)
    begin
      image = File.open("./public#{resource}", 'rb').read
      ct = IMG_CONTENT_TYPES[resource.split('.')[-1]]
      {ct: ct, file: image, size: File.size("./public#{resource}"), status: 200}
    rescue Errno::ENOENT
      p 'File can not be located!'
      {file: '', status: 404}
    end
  end

  def load_script(resource)
    begin
      file = File.open("./public/#{resource}").read
      {content: file, status: 200}
    rescue Errno::ENOENT
      p 'Script file cannot be located'
      {content: '', status: 404}
    end
  end
end
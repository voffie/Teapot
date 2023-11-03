require 'slim'

IMG_CONTENT_TYPES = {'apng' => 'image/apng',
  'avif' => 'image/avif',
  'gif' => 'image/gif',
  'jpg' => 'image/jpeg',
  'jpeg' => 'image/jpeg',
  'jfif' => 'image/jpeg',
  'pjpeg' => 'image/jpeg',
  'pjp' => 'image/jpeg',
  'png' => 'image/png',
  'svg' => 'image/svg+xml',
  'webp' => 'image/webp'
}

module ResourceManager
  def slim(resource, layout = true, locals = {})
    if !Dir.exist?('./views')
      p 'Views folder does not exist'
      ['', 500]
    else
      begin
        layout = File.open('./views/layout.slim', 'rb').read
        contents = File.open("./views/#{resource}.slim", 'rb').read
        l = Slim::Template.new { layout }
        c = Slim::Template.new { contents }.render(nil, locals)
        l.render { c }
      rescue Errno::ENOENT
        p "Can not locate #{resource}"
        ['', 500]
      end
    end
  end

  def css(resource)
    if Dir.exist?('./public/css')
      begin
        File.open("./public/css#{resource}").read
      rescue Errno::ENOENT
        p 'CSS-file not found!'
        ['', 500]
      end
    else
      begin
        File.open("./public#{resource}").read
      rescue Errno::ENOENT
        p 'CSS-file not found!'
        ['', 500]
      end
    end
  end

  def load_img(resource)
    if Dir.exist?('./public/img')
      begin
        image = File.open("./public/img#{resource}", 'rb').read
        ct = IMG_CONTENT_TYPES[resource.split('.')[-1]]
        [ct, image, File.size("./public#{resource}")]
      rescue Errno::ENOENT
        p 'File can not be located!'
        ['', 500]
      end
    else
      begin
        image = File.open("./public#{resource}", 'rb').read
        ct = IMG_CONTENT_TYPES[resource.split('.')[-1]]
        [ct, image, File.size("./public#{resource}")]
      rescue Errno::ENOENT
        p 'File can not be located!'
        ['', 500]
      end
    end
  end
end
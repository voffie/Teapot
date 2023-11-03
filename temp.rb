MAX_RESPONSE_LENGTH = 5000

parsed_data = @parser.parsed_request
case parsed_data[:method]
when 'GET'
  if parsed_data[:Accept].include?('text/css')
    response = Response.new(@resourceManager.css(parsed_data[:resource]), 200)
    response.change_content_type('text/css')
  elsif @img_endings.include?(parsed_data[:resource].split('.')[1].to_s)
    type, content, size = @resourceManager.load_img(parsed_data[:resource])
    response = Response.new(content, 200)
    response.change_content_type(type)
    response.change_content_length(size)
  elsif parsed_data[:resource].end_with?('js') || parsed_data[:resource].end_with?('ts')
    response = Response.new(File.read(parsed_data[:resource][1..].to_s), 200)
    response.change_content_type('*/*')
  elsif @router.get_routes[parsed_data[:resource].to_s].nil?
    response = Response.new('Error', 404)
  else
    response = Response.new('No body')
    @router.get_routes[parsed_data[:resource].to_s].call(response)
  end
end
puts 'Outgoing:'
if response.create_response.length < MAX_RESPONSE_LENGTH
  response.print
else
  puts "#{parsed_data[:resource]} as binary".yellow
end
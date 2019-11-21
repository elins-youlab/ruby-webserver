class Response
  attr_reader :request, :web_root

  def initialize(request, web_root)
    @request = request
    @web_root = web_root
  end

  def to_s
    response = "#{status_line}\r\n"
    response << all_headers
    response << "\r\n"
    response << content
    response
  end

  def status_line
    @status_line ||= "HTTP/1.1 #{status}"
  end

  private

  def status
    file_exists? ? 200 : 404
  end

  def all_headers
    {
      'Content-Type' => content_type,
      'Content-Length' => content.length
    }.map { |k, v| "#{k}: #{v}\r\n" }.reduce(:+)
  end

  def header
    "Content-Type: #{content_type}\r\n"
  end

  def content_type
    if !file_exists? || file_name.end_with?('.html')
      'text/html'
    else
      'application/octet-stream'
    end
  end

  def content
    if file_exists?
      file_content
    elsif not_found_file_exists?
      not_found_content
    else
      '404'
    end
  end

  def file_exists?
    @file_exists ||= File.file?(file_path)
  end

  def file_content
    @file_content ||= File.read(file_path)
  end

  def file_path
    File.join(web_root, file_name)
  end

  def file_name
    if request.path == '/'
      '/index.html'
    else
      request.path
    end
  end

  def not_found_file_exists?
    @not_found_file_exists ||= File.file?(not_found_file_path)
  end

  def not_found_content
    @not_found_content ||= File.read(not_found_file_path)
  end

  def not_found_file_path
    File.join(web_root, not_found_file_name)
  end

  def not_found_file_name
    '404.html'
  end
end
class Request
  attr_reader :method, :path, :params, :protocol

  def initialize(raw)
    @method, full_path, @protocol = raw.split(' ')
    @path, query = full_path.split('?')
    @params = parse_params(query)
  end

  private

  def parse_params(query)
    return {} unless query

    query.split('&').each_with_object({}) do |param_string, params|
      param, value = param_string.split('=')
      params[param] = value
    end
  end
end
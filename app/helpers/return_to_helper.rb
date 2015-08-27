module ReturnToHelper
  def return_to_info
    { from:  request_path}
  end

  def request_path
    request.fullpath == '/' ? nil : remove_from(request.fullpath)
  end

  def remove_from(path)
    if idx = path.rindex('?')
      get_paras = path[(idx+1)..(-1)].split('&')
      get_paras.reject! do |para|
        para.start_with? 'from='
      end
      if get_paras.any?
        path[0..idx] + get_paras.join('&')
      else
        path[0...idx]
      end
    else
      path
    end
  end
end

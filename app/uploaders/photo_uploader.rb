# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "photos/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{original_filename}-#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end

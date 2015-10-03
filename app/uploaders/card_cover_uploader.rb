class CardCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  process resize_to_fill: [360, 360]
  
  if !Rails.env.test?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end

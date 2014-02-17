display_file = Dir.glob("{/bin,/usr/bin,/usr/local/bin}/display").first

Paperclip.options[:image_magick_path] = File.dirname(display_file) if display_file
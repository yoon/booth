#!/usr/bin/env ruby
require 'rubygems'
require 'RMagick'
include Magick

# Creates a composite from four photos
# [ A ] [  B ] [  C ] [  D ]
# gapimagegapimagegapimagega
# [ A ] [  B ] [  C ] [  D ]
 
class BoothPhoto
  IMAGE_SIZE      = [524, 349] # width, height, in pixels
  COMPOSITE_SIZE  = [2400, 1200] # columns, rows, in pixels
  BORDER          = 38 # 76 pixels total, bringing image to 425x600 or (1.43in x 2in @300dpi)
  GAP_HEIGHT      = 350
  
  def initialize(paths = [])
    @photos = []
    @comp = Image.new( COMPOSITE_SIZE )
    
    collect_photos( paths )
    add_photos_to_composite
  end

  def grayscale!
    @comp = @comp.quantize(256,GRAYColorspace)
  end
  def oil_paint!
    @comp = @comp.oil_paint(1.0)
  end
  def sepia!
    @comp = @comp.sepiatone()
  end
  def display
    @comp.display   
  end
  def save(file_name)
    @comp.write(file_name)
  end

  private
  
  def collect_photos(paths)
    paths.each do |path|
      @photos << ImageList.new(path).thumbnail!(IMAGE_SIZE).border!(BORDER, BORDER, "#f0f0ff")
    end
  end

  def add_photos_to_composite
    add_row(0)
    add_gap
    add_row(IMAGE_SIZE[1] + (BORDER * 2) + GAP_HEIGHT)
  end
  
  def add_row(y_offset)
    offset = 0
    @photos.each do |photo|
      @comp.composite!( photo, NorthWestGravity , offset , y_offset, AtopCompositeOp )
      offset += photo.columns
    end 
  end

end

b = BoothPhoto.new(%w(IMG_9671.JPG IMG_9672.JPG IMG_9673.JPG IMG_9674.JPG))
b.grayscale!
#b.sepia!
b.oil_paint!
b.save("photo_composite.jpg")

exit

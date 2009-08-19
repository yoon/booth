#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'
include Magick

class BoothPhoto
  
  IMAGES_ROWS = 2
  BORDER = 5
  GAP=0.25

  attr_reader :row_height, :total_columns
  
  def initialize(photo_uris = [])
    collect_photos(photo_uris)  
	@gap_actual = row_height * IMAGES_ROWS * GAP
    # Making the composite image to fit all the photos
    @comp = Image.new(total_columns,(row_height*IMAGES_ROWS)+@gap_actual)
    add_photos_to_composite
  end

  def grayscale!
    @comp = @comp.quantize(256,GRAYColorspace)
  end
 
  def display
    @comp.display   
  end

  def oil_paint!
    @comp = @comp.oil_paint(1.0)
  end
  
  def sepia!
    @comp = @comp.sepiatone()
  end

  def save(file_name)
    @comp.write(file_name)
  end

  private
  def collect_photos(photo_uris)
    @photos = []
    @total_columns = 0
    @row_height = 0
    photo_uris.each do |path|
      photo = ImageList.new(path)
	  photo.thumbnail!(0.50)
      photo.border!(BORDER, BORDER, "#f0f0ff") #Adding border
      @total_columns += photo.columns
      if photo.rows > @row_height
        @row_height = photo.rows # Getting the maxheight for the row
      end
      @photos << photo
    end

  end

  def add_photos_to_composite
    IMAGES_ROWS.times do |t_row|
      offset = 0
      @photos.each do |photo|
        @comp.composite!(photo,NorthWestGravity,offset,(@row_height*t_row)+(t_row*@gap_actual),AtopCompositeOp)
        offset += photo.columns
      end
    end
  end

end

b = BoothPhoto.new(%w(IMG_9671.JPG IMG_9672.JPG IMG_9673.JPG IMG_9674.JPG))
b.grayscale!
#b.sepia!
b.oil_paint!
b.save("photo_composite.jpg")

exit

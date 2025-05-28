
def get_data(game,this_dungeon,floor,w,h,n):
  f = open(game.gamebinary, "rb")
  
  seek_to = game.tower_map[this_dungeon.tower]
  seek_to = seek_to + 56
  seek_to = seek_to + this_dungeon.floor_dataoffset[floor]
  seek_to = seek_to + (this_dungeon.floor_width[floor] * h * 2)
  seek_to = seek_to + (w * 2)
  seek_to = seek_to + n
  f.seek(seek_to)

  o = int.from_bytes(f.read(1), byteorder='big')

  f.close
  return(o)
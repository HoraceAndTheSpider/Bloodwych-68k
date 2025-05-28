
class DungeonTower():
  def __init__(self,gameid):
    setattr(self, 'floor_width',[0,0,0,0,0,0,0,0])
    setattr(self, 'floor_height',[0,0,0,0,0,0,0,0])
    setattr(self, 'floor_offsetx',[0,0,0,0,0,0,0,0])
    setattr(self, 'floor_offsety',[0,0,0,0,0,0,0,0])
    setattr(self, 'floor_dataoffset',[0,0,0,0,0,0,0,0])
    setattr(self, 'floor_specialx',0)
    setattr(self, 'floor_specialy',0)
    setattr(self, 'floor_specialoffset',0)
    setattr(self, 'floor_number',0)
    setattr(self, 'tower',0)
    pass



  def GetDungeon(self, game, dungeon):
    f = open(game.gamebinary, "rb")
   
    self.tower = dungeon
    f.seek (game.tower_map[dungeon])
   
    # get the floor sizes
    for q in range(8):
      self.floor_width[q] = int.from_bytes(f.read(1), byteorder='big')
    for q in range(8):
      self.floor_height[q] = int.from_bytes(f.read(1), byteorder='big')

    # get the data offsets
    for q in range(8):
      self.floor_dataoffset[q] = int.from_bytes(f.read(2), byteorder='big')

    # get the floor offsets
    for q in range(8):
      self.floor_offsetx[q] = int.from_bytes(f.read(1), byteorder='big')
    for q in range(8):
      self.floor_offsety[q] = int.from_bytes(f.read(1), byteorder='big')

    # get the special floor daata
    self.floor_specialx = int.from_bytes(f.read(2), byteorder='big')
    self.floor_specialy = int.from_bytes(f.read(2), byteorder='big')
    self.floor_specialoffset = int.from_bytes(f.read(2), byteorder='big') 

    # get the number of floors available
    self.floor_number = int.from_bytes(f.read(2), byteorder='big')  



    for att in dir(self):
      if not att.startswith('_'):
          print (att, getattr(self,att))

    f.close
    return


# example data from mod0 (the keep)
#0C 15 0F 1F 13 04 00 00  << x sizes of floor 
#01 15 0F 1F 13 05 00 00  << y sizes of floor
# data size for each floor
#00 00 
#00 18 
#03 8A 
#05 4C 
#0C CE 
#0F A0 
#0F C8 
#00 00 
#08 05 08 00 06 0B 00 00 <<< X offsets of Floors
#05 05 08 00 06 0C 00 00 <<< Y offsets of Floors
# the size, x,y, data, for a specific floor
#00 15 00 15 00 18 
#00 05 << the number of floors


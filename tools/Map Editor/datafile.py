
#!/usr/bin/python
import os
class GameSetup:
  def __init__(self,gamebin):

    setattr(self, 'tower_map',[0,0,0,0,0,0])
    setattr(self, 'tower_obj',[0,0,0,0,0,0])
    setattr(self, 'tower_switches',[0,0,0,0,0,0])
    setattr(self, 'tower_triggers',[0,0,0,0,0,0])
    setattr(self, 'tower_monsters',[0,0,0,0,0,0])
    setattr(self, 'monster_count',0)
    setattr(self, 'dungeon_starts',0)
    setattr(self, 'keep_starts',0)
    setattr(self, 'keep_floors',0)
    setattr(self, 'blu_gems',0)
    setattr(self, 'tan_gems',0)
    setattr(self, 'champion_stats',0)
    setattr(self, 'champion_pockets',0)
    setattr(self, 'spell_text',0)
    setattr(self, 'spell_names',0)
    setattr(self, 'champion_names',0)
    setattr(self, 'hardcode_1',0)
    setattr(self, 'hardcode_2',0)
    setattr(self, 'character_bodies',0)
    setattr(self, 'character_heads',0)
    setattr(self, 'character_colours',0)
    setattr(self, 'monster_palette',0)
    setattr(self, 'summon_colours',0)
    setattr(self, 'beholder_colours',0)
    setattr(self, 'behemoth_colours',0)
    setattr(self, 'crab_colours',0)
    setattr(self, 'dragon_colours',0)   
    setattr(self, 'entropy_colours',0) 
    setattr(self, 'gametype',0) 
    setattr(self, 'gamebinary',"") 
    setattr(self, 'tower_names',["","","","","",""]) 
    
    # which game (this is to be improved)
    self.gamebinary = gamebin

    if self.gamebinary.find("439") != -1:
      self.gameid = "439"
    elif self.gamebinary.find("1927") != -1:
      self.gameid = "1927"
    elif self.gamebinary.find("102") != -1:
      self.gameid = "102"
    elif self.gamebinary.find("43") != -1:
      self.gameid = "43"
      self.gametype = 1
    elif self.gamebinary.find("DEMO") != -1:
      self.gameid = "ST_DEMO"
      self.gametype = 2


    # tower name
    if self.gametype == 0:
        self.tower_names[0] = "The Keep"
        self.tower_names[1] = "Serpent Tower"
        self.tower_names[2] = "Moon Tower"
        self.tower_names[3] = "Dragon Tower"
        self.tower_names[4] = "Chaos Tower"
        self.tower_names[5] = "Zendick's Tower"
    elif self.gametype == 1:
        self.tower_names[0] = "Serpent Dungeon"
        self.tower_names[1] = "Chaos Dungeon"
        self.tower_names[2] = "Moon Tower"
        self.tower_names[3] = "Dragon Dungeon"
        self.tower_names[4] = ""
        self.tower_names[5] = ""
    elif self.gametype == 0:
        self.tower_names[0] = "Modified Keep"


    pass


  # allows us to read the 'datamap' which tells us where
  # all the different elements of the game are in the binary
  def GetLocations(self):

    f = open("editor/" + str(self.gameid) + ".datamap", "rb")
    c=0
    size = os.path.getsize("editor/" + str(self.gameid) + ".datamap")
    
    #print (size)
    while c< size:
      n = int.from_bytes(f.read(4), byteorder='big')

      d=int(c/4)

      # Tower Map Data
      if d >= 0 and d <=5: 
        self.tower_map[d] = n
      # Tower Obj Data
      if d >= 6 and d <=11: 
        self.tower_obj[d-6] = n
      # Tower Switch Data
      if d >= 12 and d <=17: 
        self.tower_switches[d-12] = n
      # Tower Trigger Data
      if d >= 18 and d <=23: 
        self.tower_triggers[d-18] = n
      # Tower Monster Data
      if d >= 24 and d <=29: 
        self.tower_monsters[d-24] = n

      # misc tower / map information
      if d == 30:
        self.monster_count = n
      if d == 32:
        self.dungeon_starts = n
      if d == 33:
        self.keep_starts = n
      if d == 34:
        self.keep_floors = n
      if d == 36:
        self.blu_gems = n
      if d == 37:
        self.tan_gems = n
      if d == 44:
        self.scroll_refs = n
      if d == 45:
        self.scroll_texts = n
      if d == 46:
        self.hardcode_1 = n
      if d == 47:
        self.hardcode_2 = n

      # information for Champion Editor
      if d == 38:
        self.champion_stats = n
      if d == 39:
        self.champion_pockets = n
      if d == 40:
        self.spell_text = n
      if d == 41:
        self.spell_names = n
      if d == 42:
        self.champion_names = n


      # Graphics  / Character Editor
      if d == 48:
        self.character_bodies = n
      if d == 49:
        self.character_heads = n
      if d == 50:
        self.character_colours = n
      if d == 52:
        self.monster_palette = n
      if d == 52:
        self.summon_colours = n
      if d == 53:
        self.beholder_colours = n
      if d == 54:
        self.behemoth_colours = n
      if d == 55:
        self.crab_colours = n
      if d == 56:
        self.dragon_colours = n
      if d == 57:
        self.entropy_colours = n

      # move along
      c = c + 4
      f.seek(c)

# print the output
    for att in dir(self):
      if not att.startswith('_'):
          print (att, getattr(self,att))

    f.close()

    return

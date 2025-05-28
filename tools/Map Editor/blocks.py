import bit_tools, palette, pygame, myfont


# --- TYPE 0  BLANKS
class Space():
  def __init__(self,aa,bb,cc,dd):
    setattr(self, 'future',(aa*16)+bb)

  def draw_icon(self, screen,inx,iny):

    acol = palette.make_palette()
    bcol = (0,0,0,0)  

    if self.future != 0:
      bcol = acol[1]
    
    #if cc != 0:
    #  bcol = acol[3]  

    pygame.draw.rect(screen,bcol,(inx,iny,14,14))
    return

# --- TYPE 1  WALLS
class Walls():
  def __init__(self,aa,bb,cc,dd): 

    ee =(aa*16)+bb
    setattr(self, 'type',"")

    # SHELVES
    if bb % 4==0 : # -- shelf 
      setattr(self, 'type',"shelf")
      setattr(self, 'conceal',False)
      if bit_tools.testBit(dd,3)==True:     
        setattr(self, 'conceal',True)

    # SIGNAGE
    if bb % 4==1 : # -- sign
      setattr(self, 'type',"sign")
      setattr(self, 'sign',"none")
      if ee==1:
        setattr(self, 'sign',"seed")      
      elif ee==5:
        setattr(self, 'sign',"serpent")
      elif ee==9:
        setattr(self, 'sign',"dragon")
      elif ee==13:
        setattr(self, 'sign',"moon")
      elif ee==17:
        setattr(self, 'sign',"chaos")
      else:
        setattr(self, 'sign',"text")

    # SWITCHES
    if bb % 4==2 : # -- if switch
      setattr(self, 'type',"switch")
      setattr(self, 'clicked',False)

      if ee >= 8 : # switch
        setattr(self, 'switchref',int(ee / 8))

        if bb==0x2 or bb==0xA:
          setattr(self, 'clicked',False)
        elif bb==6 or bb==0x0E:
         setattr(self, 'clicked',True)          
        else:
          setattr(self, 'switchref',-1)
          setattr(self, 'clicked',False)    

      else:   # shooter
        setattr(self, 'switchref',0)


    # CRYSTAL & GEM SLOTS
    if bb % 4==3 : # -- if slot
      setattr(self, 'type',"slot")
      setattr(self, 'slot',"serpent")

      if ee>=0x0 and ee<=0x7 : # -- serpent 
        setattr(self, 'slot',"serpent")
      elif ee>=0x8 and ee<=0xF : # -- chaos 
        setattr(self, 'slot',"chaos")
      elif ee>=0x10 and ee<=0x17 : # -- dragon
        setattr(self, 'slot',"dragon")
      elif ee>=0x18 and ee<=0x1F : # -- moon  
        setattr(self, 'slot',"moon")
      elif ee>=0x20 and ee<=0x27 : # -- grey  
        setattr(self, 'slot',"grey")
      elif ee>=0x28 and ee<=0x2F : # -- bluish
        setattr(self, 'slot',"bluish")
      elif ee>=0x30 and ee<=0x37 : # -- brown 
        setattr(self, 'slot',"brown")
      elif ee>=0x38 and ee<=0x3F : # -- tan 
        setattr(self, 'slot',"tan")
      elif ee>=0x40 and ee<=0xFF : # -- everything else that isnt 
        setattr(self, 'slot',"unknown")

      # is the slot filled?
      setattr(self, 'filled',False)
      if bb==0x3 or bb==0xB : # --- if full
        setattr(self, 'filled',True)
      elif bb==0x7 or bb==0xF : # -- if empty
        setattr(self, 'filled',False)

    # direction   
    setattr(self, 'facing',"unknown") 

    if cc==8 or cc==12:
      setattr(self, 'facing',"north")      
    elif cc==9 or cc==13:
      setattr(self, 'facing',"east")      
    elif cc==10 or cc==14:
      setattr(self, 'facing',"south")  
    elif cc==11 or cc==15:
      setattr(self, 'facing',"west")  


  def draw_icon(self, screen,inx,iny):

    acol = palette.make_palette()
    bcol = acol[4]  
    
    # default wall
    pygame.draw.rect(screen,bcol,(inx,iny,14,14))

    incol = acol[15]  
    outcol = acol[15]  

    # shelf colours
    if self.type == "shelf":
      incol = acol[9]
      outcol = acol[9]

      if self.conceal == True:
        incol = acol[8]

    # sign colours
    if self.type == "sign":
      if self.sign =="seed":
        incol = acol[14]
      if self.sign =="serpent":
        incol = acol[6]
      if self.sign =="dragon":
        incol = acol[12]
      if self.sign =="moon":
        incol = acol[7]
      if self.sign =="chaos":
        incol = acol[13]
      if self.sign =="text":
        incol = acol[2]

      outcol = incol

    # sign / shelf drawing
    if self.type == "shelf" or self.type == "sign":
      if self.facing == "north":
        pygame.draw.rect(screen,outcol,(inx+2,iny,10,8)) 
        pygame.draw.rect(screen,incol,(inx+4,iny,6,6)) 

      if self.facing == "east":
        pygame.draw.rect(screen,outcol,(inx+6,iny+2,8,10)) 
        pygame.draw.rect(screen,incol,(inx+8,iny+4,6,6)) 

      if self.facing == "south":
        pygame.draw.rect(screen,outcol,(inx+2,iny+6,10,8))
        pygame.draw.rect(screen,incol,(inx+4,iny+8,6,6)) 

      if self.facing == "west":
        pygame.draw.rect(screen,outcol,(inx,iny+2,8,10)) 
        pygame.draw.rect(screen,incol,(inx,iny+4,6,6)) 

    # crystal / gem colours
    if self.type == "slot":
      if self.slot =="serpent":
        outcol = acol[6]
      elif self.slot =="dragon":
        outcol = acol[12]
      elif self.slot =="moon":
        outcol = acol[7]
      elif self.slot =="chaos":
        outcol = acol[13]
      elif self.slot =="grey":
        outcol = acol[3]      
      elif self.slot =="bluish":
        outcol = acol[8]      
      elif self.slot =="brown":
        outcol = acol[9]      
      elif self.slot =="tan":
        outcol = acol[10]   
      else:
        outcol = acol[15] 

      if self.filled == True:
        incol = outcol        
      else:
        incol = acol[0] 

    if self.type == "switch":
    # switches drawing

    #  incol = acol[7]
    #    outcol = 12
      if self.switchref == 0:
        outcol = acol[0] 
      elif self.switchref < 0:
        outcol = acol[15] 
      else:
        outcol = acol[14] 

      if self.clicked == False:
        incol = outcol        
      else:
        incol = acol[0]

    #  outcol = acol[6]
    #  incol = acol[5]

    # slots / switches drawing
    if self.type == "slot" or self.type == "switch":
      if self.facing == "north":
        pygame.draw.rect(screen,outcol,(inx+4,iny,6,6)) 
        pygame.draw.rect(screen,outcol,(inx+6,iny+6,2,2)) 
        pygame.draw.rect(screen,incol,(inx+5,iny,4,3)) 

      if self.facing == "east":
        pygame.draw.rect(screen,outcol,(inx+8,iny+4,6,6))
        pygame.draw.rect(screen,outcol,(inx+6,iny+6,2,2)) 
        pygame.draw.rect(screen,incol,(inx+11,iny+5,3,4)) 

      if self.facing == "south":
        pygame.draw.rect(screen,outcol,(inx+4,iny+8,6,6))
        pygame.draw.rect(screen,outcol,(inx+6,iny+6,2,2))
        pygame.draw.rect(screen,incol,(inx+5,iny+11,4,3)) 

      if self.facing == "west":
        pygame.draw.rect(screen,outcol,(inx,iny+4,6,6))
        pygame.draw.rect(screen,outcol,(inx+6,iny+6,2,2))
        pygame.draw.rect(screen,incol,(inx,iny+5,3,4)) 

        


# --- TYPE 2  WOOD
class Wood():
  def __init__(self,aa,bb,cc,dd): 

    ee = (aa*16) + bb
    # a lock, affects all doors
    if bit_tools.testBit(cc,0) != 0:
      setattr(self, 'locked',True)
    else:
      setattr(self, 'locked',False)

    setattr(self, 'north',"none")  
    setattr(self, 'east',"none")  
    setattr(self, 'south',"none")  
    setattr(self, 'west',"none")  

    if bit_tools.testBit(ee,0) != 0 and bit_tools.testBit(ee,1)==0: #  %%% WALL N   
      setattr(self, 'north',"wall")      
    if bit_tools.testBit(ee,2)!= 0 and bit_tools.testBit(ee,3)==0 : #  %%% WALL E   
      setattr(self, 'east',"wall")    
    if bit_tools.testBit(ee,4)!= 0 and bit_tools.testBit(ee,5)==0 : #  %%% WALL S   
      setattr(self, 'south',"wall")    
    if bit_tools.testBit(ee,6)!= 0 and bit_tools.testBit(ee,7)==0 : #  %%% WALL W   
      setattr(self, 'west',"wall")    

    if bit_tools.testBit(ee,0)==0 and bit_tools.testBit(ee,1)!= 0 : #  %%% OPEN DOOR N   
      setattr(self, 'north',"open")      
    if bit_tools.testBit(ee,2)==0 and bit_tools.testBit(ee,3)!= 0 : #  %%% OPEN DOOR E   
      setattr(self, 'east',"open")    
    if bit_tools.testBit(ee,4)==0 and bit_tools.testBit(ee,5)!= 0 : #  %%% OPEN DOOR S   
      setattr(self, 'south',"open")    
    if bit_tools.testBit(ee,6)==0 and bit_tools.testBit(ee,7)!= 0 : #  %%% OPEN DOOR W   
      setattr(self, 'west',"open") 

    if bit_tools.testBit(ee,0)!= 0 and bit_tools.testBit(ee,1) != 0: #  %%% CLOSED DOOR N   
      setattr(self, 'north',"closed")  
          
    if bit_tools.testBit(ee,2)!= 0 and bit_tools.testBit(ee,3) != 0 : #  %%% CLOSED DOOR E  
      setattr(self, 'east',"closed")    

    if bit_tools.testBit(ee,4)!= 0 and bit_tools.testBit(ee,5) != 0 : #  %%% CLOSED DOOR S   
      setattr(self, 'south',"closed")    
    if bit_tools.testBit(ee,6)!= 0 and bit_tools.testBit(ee,7) != 0 : #  %%% CLOSED DOOR W   
      setattr(self, 'west',"closed") 


  def draw_icon(self, screen,inx,iny):
    acol = palette.make_palette()

    # === Draw on the Walls
    # north
    if self.north != "none":
      bcol = acol[9]  
      if self.locked == True and self.north != "wall":
        bcol = acol[12]
      pygame.draw.rect(screen,bcol,(inx,iny,14,2))

    # east 
    if self.east != "none":
      bcol = acol[9]  
      if self.locked == True and self.east != "wall":
        bcol = acol[12]
      pygame.draw.rect(screen,bcol,(inx+12,iny,2,14))

    # south
    if self.south != "none":
      bcol = acol[9]  
      if self.locked == True and self.south != "wall":
        bcol = acol[12]
      pygame.draw.rect(screen,bcol,(inx,iny+12,14,2))

    # west
    if self.west != "none":
      bcol = acol[9]  
      if self.locked == True and self.west != "wall":
        bcol = acol[12]
      pygame.draw.rect(screen,bcol,(inx,iny,2,14))


    # === Draw on the Doors
    # north
    if self.north == "open" or self.north == "closed":
      bcol = acol[11]
      if self.north == "open":
        bcol = acol[0]
      pygame.draw.rect(screen,bcol,(inx+3,iny,8,2))

    # east 
    if self.east == "open" or self.east == "closed":
      bcol = acol[11]
      if self.east == "open":
        bcol = acol[0]
      pygame.draw.rect(screen,bcol,(inx+12,iny+3,2,8))

    # south
    if self.south == "open" or self.south == "closed":
      bcol = acol[11]
      if self.south == "open":
        bcol = acol[0]
      pygame.draw.rect(screen,bcol,(inx+3,iny+12,8,2))

    # west
    if self.west == "open" or self.west == "closed":
      bcol = acol[11]
      if self.west == "open":
        bcol = acol[0]
      pygame.draw.rect(screen,bcol,(inx,iny+3,2,8))
   

# --- TYPE 3  MISC
class Misc():
  def __init__(self,aa,bb,cc,dd): 
    pass
    if bb == 0:
      setattr(self,'objtype',"bed")
    elif bb == 1:
      setattr(self,'objtype',"pillar")
    else:
      setattr(self,'objtype',"Unknown")    

  def draw_icon(self, screen,inx,iny):

    acol = palette.make_palette()
    bcol = acol[4] 

    # pillar
    if self.objtype == "pillar":
      pygame.draw.rect(screen,acol[4],(inx+3,iny+3,8,8))

    # bed
    elif self.objtype == "bed":

      pygame.draw.rect(screen,acol[5],(inx,iny,14,14))
      tempfont = myfont.GameFont()
      tempfont.SetColour(acol[0])
      text = tempfont.TextObject("B")
      screen.blit(text, (inx+3, iny+0))
    
    # some mutant
    else:
      pygame.draw.rect(screen,acol[5],(inx,iny,14,14))
  

# --- TYPE 4  STAIRS
class Stairs():
  def __init__(self,aa,bb,cc,dd): 
    if bb % 2==0 : # --- stairs up
      setattr(self,"elevation",1)
    elif bb % 2==1 : # --- stairs down
      setattr(self,"elevation",0)

    if bb % 8==0 or bb % 8==1 : # -- north 
      setattr(self,"facing","north")
    if bb % 8==4 or bb % 8==5 : # -- south 
      setattr(self,"facing","south")
    if bb % 8==2 or bb % 8==3 : # -- east 
      setattr(self,"facing","east")
    if bb % 8==6 or bb % 8==7 : # -- west 
      setattr(self,"facing","west")

    # some mutant
    if aa!=0 or bb>>8:
      pygame.draw.rect(screen,acol[13],(inx,iny,14,14))
      tempfont = myfont.GameFont()
      tempfont.SetColour(acol[0])
      text = tempfont.TextObject(str(d))
      screen.blit(text, (inx+3, iny+0))
      pass
      

  def draw_icon(self, screen,inx,iny):
    acol = palette.make_palette()
    bcol = acol[11]  

    if self.elevation == 1 : # up
      bcol = acol[3]
    else : # down
      bcol = acol[2]

    # draw the 'steps'
    if self.facing == "north" or self.facing == "south":
      pygame.draw.rect(screen,bcol,(inx+0,iny+0,14,2))
      pygame.draw.rect(screen,bcol,(inx+0,iny+4,14,2))
      pygame.draw.rect(screen,bcol,(inx+0,iny+8,14,2))
      pygame.draw.rect(screen,bcol,(inx+0,iny+12,14,2))

    elif self.facing == "east" or self.facing == "west":
      pygame.draw.rect(screen,bcol,(inx+0,iny+0,2,14))
      pygame.draw.rect(screen,bcol,(inx+4,iny+0,2,14))
      pygame.draw.rect(screen,bcol,(inx+8,iny+0,2,14))
      pygame.draw.rect(screen,bcol,(inx+12,iny+0,2,14))
    else:
      pygame.draw.rect(screen,acol[15],(inx,iny,14,14))

    # draw the borders 

    bcol = acol[1]
    if self.facing != "north": # so we should draw the north one
      pygame.draw.rect(screen,bcol,(inx+0,iny+0,14,2))
    else:
      pygame.draw.rect(screen,bcol,(inx+0,iny+0,4,4))
      pygame.draw.rect(screen,bcol,(inx+10,iny+0,4,4))

    if self.facing != "east": # so we draw the east one
      pygame.draw.rect(screen,bcol,(inx+12,iny+0,2,14))
    else:
      pygame.draw.rect(screen,bcol,(inx+10,iny+0,4,4))
      pygame.draw.rect(screen,bcol,(inx+10,iny+10,4,4))

    if self.facing != "south": # so we draw the south one
      pygame.draw.rect(screen,bcol,(inx+0,iny+12,14,2))
    else:
      pygame.draw.rect(screen,bcol,(inx+0,iny+10,4,4))
      pygame.draw.rect(screen,bcol,(inx+10,iny+10,4,4))

    if self.facing != "west": # so we draw the west one
      pygame.draw.rect(screen,bcol,(inx+0,iny+0,2,14))
    else:
      pygame.draw.rect(screen,bcol,(inx+0,iny+0,4,4))
      pygame.draw.rect(screen,bcol,(inx+0,iny+10,4,4))

# --- TYPE 5  BIG DOORS
class Door():
  def __init__(self,aa,bb,cc,dd):
    
    # is door open 
    if not(bit_tools.testBit(bb,0)):
      setattr(self,'open',True)
    else:
      setattr(self,'open',False)

    # portfullis or metal door 
    if (bit_tools.testBit(bb,1) !=0): setattr(self,'portcullis',True)
    else:
      setattr(self,'portcullis', False)
    
    # is it locked 
    if (cc % 4 == 0):
      setattr(self,'locked',False)
    else:
      setattr(self,'locked',True)
    
    # what colour/type is the lock?
    if aa==0: # MAGELOCKED 
      setattr(self,'locktype',"magelock")
    elif aa==1 : # BRONZE LOCK  
      setattr(self,'locktype',"bronze")
    elif aa==2 : # IRON LOCK    
      setattr(self,'locktype',"iron")
    elif aa==3 : # SERPENT LOCK 
      setattr(self,'locktype',"serpent")
    elif aa==4 : # CHAOS LOCK   
      setattr(self,'locktype',"chaos")
    elif aa==5 : # DRAGON LOCK    
      setattr(self,'locktype',"dragon")
    elif aa==6 : # MOON LOCK
      setattr(self,'locktype',"moon")
    elif aa==7 : # CHROMATIC LOCK   
      setattr(self,'locktype',"chromatic")
    elif aa>=8 : # INVALID LOCK 
      setattr(self,'locktype',"invalid")

    if bb>=8:
      setattr(self,'locktype',"switchlock") 
      setattr(self,'locked',True)

    # does it face north\south
    if ((bb >= 0 and bb <= 3) or (bb >= 8 and bb <= 11)):
      setattr(self,'facing',1)
    else:
      setattr(self,'facing',0)

    #print ("icon2 ",hex(aa),"-",hex(bb),"-",hex(cc),"-",hex(dd))


  def draw_icon(self, screen,inx,iny):
    
    acol = palette.make_palette()

    # portfullis or metal door 
    if self.portcullis == False:
      bcol = acol[4]
    else:
      bcol = acol[2]
    
    width= 14
    height=14
    # north\south
    if self.facing==1:
      iny += 3
      height=8
    else:
      inx += 3
      width = 8

  # draw the door 
    pygame.draw.rect(screen,bcol,(inx,iny,width,height))
    
  # locks 
    #print (self.locktype)
    if self.locked == True:
      keycol = acol[15]
      if self.locktype == "magelock": keycol = acol[3]
      elif self.locktype == "bronze": keycol = acol[9]
      elif self.locktype == "iron": keycol = acol[1]
      elif self.locktype == "serpent": keycol = acol[6]
      elif self.locktype == "chaos": keycol = acol[13]
      elif self.locktype == "dragon": keycol = acol[12]
      elif self.locktype == "moon": keycol = acol[7]
      elif self.locktype == "chromatic": keycol = acol[14]
      elif self.locktype == "invalid": keycol = acol[15]
      elif self.locktype == "switchlock": keycol = acol[0]
    
      #print (self.locktype)
      if self.facing ==1:
        lockX = inx
        lockY = iny +3
        lockwidth = width
        lockheight = 2

      else:
        lockX = inx +3
        lockY = iny
        lockwidth = 2
        lockheight = height

      pygame.draw.rect(screen,keycol,(lockX,lockY,lockwidth,lockheight))
 

  #open/close 
    if self.open == True:
      if self.facing == 1:
        inx += 3
        width -=6
      else:
        iny += 3
        height -=6
        
      #draw the openness 
      pygame.draw.rect(screen,(0,0,0,0),(inx,iny,width,height))
    

    return

# --- TYPE 6  PADS
class Pads():
  def __init__(self,aa,bb,cc,dd): 

    setattr(self,'fizzle',False)
    setattr(self,'hole',False)
    setattr(self,'greenpad',False)
    setattr(self,'trigger',False)
    setattr(self,'ceiling',False)

    if bb % 4==0 : # -- blank / fizzle  
      setattr(self,'fizzle',True)
    elif bb % 4==1 : # -- floor hole
      setattr(self,'hole',True)
    elif bb % 4==2 : # -- green pad
      setattr(self,'greenpad',True)
    elif bb % 4==3 : # -- blank space
      setattr(self,'trigger',True)

    if (bb % 8>=4 and bb % 8<=8): # -- ceiling hole
      setattr(self,'ceiling',True)



  def draw_icon(self, screen,inx,iny):
    acol = palette.make_palette()
    padcol = 0

    if self.hole == True:
      padcol = acol[2]
    elif self.greenpad == True:
      padcol = acol[5]
    elif self.trigger == True:
      padcol = acol[1]

    pygame.draw.rect(screen,padcol,(inx+2,iny+2,10,10))

    if self.fizzle == True:
   # pygame.draw.rect(screen,bcol,(inx,iny,14,14))
      tempfont = myfont.GameFont()
      tempfont.SetColour(acol[8])
      text = tempfont.TextObject("F")
      screen.blit(text, (inx+3, iny+0))


# --- TYPE 7  MAGIC
class Magic():
  def __init__(self,aa,bb,cc,dd): 

    setattr(self,'magic',"None")

    if bb % 4==0 : # -- clear 
      setattr(self,'magic',"unknown")
    if bb % 4==1 : # -- firepath
      setattr(self,'magic',"firepath")
    if bb % 4==2 : # -- mindrock
      setattr(self,'magic',"mindrock")
    if bb % 4==3 : # -- formwall
      setattr(self,'magic',"formwall")

  def draw_icon(self, screen,inx,iny):
    acol = palette.make_palette()

    if self.magic == "unknown":
      incol = acol[7]  
      outcol = acol[0]  
    if self.magic == "firepath":
      incol = acol[12]  
      outcol = acol[0]  
    if self.magic == "mindrock":
      incol = acol[8]  
      outcol = acol[7]  
    if self.magic == "formwall":
      incol = acol[3]  
      outcol = acol[8]  

    pygame.draw.rect(screen,outcol,(inx,iny,14,14))
    pygame.draw.rect(screen,incol,(inx+2,iny+2,10,10))



# --- TYPE ALT  PADS
class TBC():
  def __init__(self,aa,bb,cc,dd): 
    pass
  def draw_icon(self, screen,inx,iny):
    acol = palette.make_palette()
    bcol = acol[15]  

    pygame.draw.rect(screen,bcol,(inx,iny,14,14))

    tempfont = myfont.GameFont()
    tempfont.SetColour(acol[14])
    text = tempfont.TextObject(str(dd))
    screen.blit(text, (inx+3, iny+0))
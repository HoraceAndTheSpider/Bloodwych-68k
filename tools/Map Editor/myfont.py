import pygame

class GameFont():
  def __init__(self):
   # setattr(self, 'type','font/BloodwychSimple-Regular.otf')
    setattr(self, 'type','font/SFNSDisplay.ttf')
    setattr(self, 'size',12)
    setattr(self, 'colour',(255,255,255,0))

  def SetSize(self,inSize):
    self.size = inSize

  def SetColour(self,inColour):
    self.colour = inColour

  def TextObject(self, inText):
    font = pygame.font.Font(self.type, self.size)
  
    text = font.render(inText, True, self.colour)
    return(text)


# 
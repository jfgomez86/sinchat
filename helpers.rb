module Smileys
  SMILEY_TABLE = {
    ":)"      =>    "1.gif",
    "^_^"     =>    "2.gif",
    "-_-"     =>    "3.gif",
    ":("      =>    "4.gif",
    "-.-"    =>    "5.gif",
    ":D"      =>    "6.gif",
    "o.o"     =>    "7.gif",
    "xD"      =>    "8.gif",
    ";)"      =>    "9.gif",
    ":P"      =>    "10.gif",
    ":$"      =>    "11.gif",
    "8)"      =>    "12.gif",
    ":p"      =>    "13.gif",
    ":@"      =>    "14.gif",
    "<:("     =>    "15.gif",
    "alien"   =>    "16.gif",
    "-,-"     =>    "17.gif",
    ">>"     =>    "18.gif",
    "<<"     =>    "19.gif",
    "(idea)"     =>    "20.gif",
    "lol"     =>    "21.gif",
    ":s"     =>    "22.gif",
    "<3"     =>    "23.gif",
    ":'("     =>    "24.gif",
    ":/"     =>    "25.gif",
    "(?)"     =>    "26.gif",
    "(!)"     =>    "27.gif",
    "(welcome)"     =>    "welcome.gif"
  }
  SMILEYS_DIR = "/smileys/"
  TEST = "Hola :D como estas (?) :s :("

  def parse_smileys(text)
    SMILEY_TABLE.each do |smiley, uri|
      text.gsub!(smiley, get_img_tag_for(smiley))
    end
    return text
  end

  def get_img_tag_for(smiley)
    img_tag = ["<img alt=", smiley.gsub(/[\.]/, "\\0"), " title=", smiley.gsub(/[\.]/, "\\0"), " src=", get_uri_for(smiley), "/>"].join('"')
    return img_tag
  end

  def get_uri_for(smiley)
    return [SMILEYS_DIR,SMILEY_TABLE[smiley]].join
  end

end 
include Smileys

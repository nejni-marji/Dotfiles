#!/usr/bin/env python3
from datetime import datetime

hourNames = [
    [ "One o’clock",
      "Five past one",
      "Ten past one",
      "Quarter past one",
      "Twenty past one",
      "Twenty-five past one",
      "Half past one",
      "Twenty-five to two",
      "Twenty to two",
      "Quarter to two",
      "Ten to two",
      "Five to two" ],
    [ "Two o’clock",
      "Five past two",
      "Ten past two",
      "Quarter past two",
      "Twenty past two",
      "Twenty-five past two",
      "Half past two",
      "Twenty-five to three",
      "Twenty to three",
      "Quarter to three",
      "Ten to three",
      "Five to three" ],
    [ "Three o’clock",
      "Five past three",
      "Ten past three",
      "Quarter past three",
      "Twenty past three",
      "Twenty-five past three",
      "Half past three",
      "Twenty-five to four",
      "Twenty to four",
      "Quarter to four",
      "Ten to four",
      "Five to four" ],
    [ "Four o’clock",
      "Five past four",
      "Ten past four",
      "Quarter past four",
      "Twenty past four",
      "Twenty-five past four",
      "Half past four",
      "Twenty-five to five",
      "Twenty to five",
      "Quarter to five",
      "Ten to five",
      "Five to five" ],
    [ "Five o’clock",
      "Five past five",
      "Ten past five",
      "Quarter past five",
      "Twenty past five",
      "Twenty-five past five",
      "Half past five",
      "Twenty-five to six",
      "Twenty to six",
      "Quarter to six",
      "Ten to six",
      "Five to six" ],
    [ "Six o’clock",
      "Five past six",
      "Ten past six",
      "Quarter past six",
      "Twenty past six",
      "Twenty-five past six",
      "Half past six",
      "Twenty-five to seven",
      "Twenty to seven",
      "Quarter to seven",
      "Ten to seven",
      "Five to seven" ],
    [ "Seven o’clock",
      "Five past seven",
      "Ten past seven",
      "Quarter past seven",
      "Twenty past seven",
      "Twenty-five past seven",
      "Half past seven",
      "Twenty-five to eight",
      "Twenty to eight",
      "Quarter to eight",
      "Ten to eight",
      "Five to eight" ],
    [ "Eight o’clock",
      "Five past eight",
      "Ten past eight",
      "Quarter past eight",
      "Twenty past eight",
      "Twenty-five past eight",
      "Half past eight",
      "Twenty-five to nine",
      "Twenty to nine",
      "Quarter to nine",
      "Ten to nine",
      "Five to nine" ],
    [ "Nine o’clock",
      "Five past nine",
      "Ten past nine",
      "Quarter past nine",
      "Twenty past nine",
      "Twenty-five past nine",
      "Half past nine",
      "Twenty-five to ten",
      "Twenty to ten",
      "Quarter to ten",
      "Ten to ten",
      "Five to ten" ],
    [ "Ten o’clock",
      "Five past ten",
      "Ten past ten",
      "Quarter past ten",
      "Twenty past ten",
      "Twenty-five past ten",
      "Half past ten",
      "Twenty-five to eleven",
      "Twenty to eleven",
      "Quarter to eleven",
      "Ten to eleven",
      "Five to eleven" ],
    [ "Eleven o’clock",
      "Five past eleven",
      "Ten past eleven",
      "Quarter past eleven",
      "Twenty past eleven",
      "Twenty-five past eleven",
      "Half past eleven",
      "Twenty-five to twelve",
      "Twenty to twelve",
      "Quarter to twelve",
      "Ten to twelve",
      "Five to twelve" ],
    [ "Twelve o’clock",
      "Five past twelve",
      "Ten past twelve",
      "Quarter past twelve",
      "Twenty past twelve",
      "Twenty-five past twelve",
      "Half past twelve",
      "Twenty-five to one",
      "Twenty to one",
      "Quarter to one",
      "Ten to one",
      "Five to one" ]
]

now = datetime.now()
hours, minutes = now.hour, now.minute

# code ported from FuzzyClock.qml
sector = 0
realHour = 0

# i quote from the original code:
#    this formula has been determined by carefully filling a spreadsheet
#    and looking at the numbers :)
sector = ((minutes + 7) / 15 * 3)
sector = (int(sector / 3) * 3)

if (hours % 12 > 0):
    realHour = hours % 12 - 1
else:
    realHour = 12 - (hours % 12 + 1)

sector = sector
if (sector == 12):
    realHour += 1
    if (realHour >= len(hourNames)):
        realHour = 0
    sector = 0

# final fuzzy time
print(realHour, sector)
fuzzy_time = hourNames[realHour][sector].lower()


# emoji clock written by me
emoji=['🌌','🌌','🌌','🌌','🌌','🌇','🌇','🌇','🏙️','🏙️','🏙️','🏙️','🏙️','🌆','🌆','🌆','🌆','🌆','🌆','🌃','🌃','🌃','🌃','🌌']

emoji_hour = emoji[hours-1]


# date format
date_long = now.strftime('%a, %b %-d,')
date_short = now.strftime('%a, %b %-d %H:%M')



print(' '.join([date_long, fuzzy_time, emoji_hour]))
print(' '.join([date_short, emoji_hour]))

# testing an idea
clock_icons = ['○','◔','◑','◕']
clock_sector = int((sector)/3)
clock_hour = realHour+1
print(clock_sector)
clock_min  = clock_icons[clock_sector]
print(clock_hour, clock_min)


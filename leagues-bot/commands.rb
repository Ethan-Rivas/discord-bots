# Require Gnar Bot
require './gnar-bot'

# Require this for create http requests
require 'uri'
require 'net/http'

#####################################
##                                 ##
##   Join bot to current Channel   ##
##                                 ##
#####################################

# Here's where the magic happens
@bot.command(:connect) do |event|
  # The `voice_channel` method returns the voice channel the user is currently in, or `nil` if the user is not in a
  # voice channel.
  channel = event.user.voice_channel

  # Here we return from the command unless the channel is not nil (i. e. the user is in a voice channel). The `next`
  # construct can be used to exit a command prematurely, and even send a message while we're at it.
  next "You're not in any voice channel!" unless channel

  # The `voice_connect` method does everything necessary for the bot to connect to a voice channel. Afterwards the bot
  # will be connected and ready to play stuff back.
  @bot.voice_connect(channel)
  "Connected to voice channel: #{channel.name}"
end

#####################################
##                                 ##
##    Summoner Leagues Request     ##
##                                 ##
#####################################

@bot.command(:league, description: 'Returns the current division of a Summoner', usage: '!league summoner_name') do |*args|
  event = args.shift
  summoner_name = args.join(' ')

  # Request Summoner basic data
  summoner_id = @taric.summoner_by_name(summoner_name: summoner_name).body['id']

  # Request Summoner current leagues (SoloQ and Flex)
  league = @taric.league_positions(summoner_id: summoner_id).body

  # Return League data based on Summoner ID
  event.respond "Summoner: " + league[0]['playerOrTeamName'] + "\n\nName: " + league[0]['leagueName'] +  " | Tier: " + league[0]['tier'] + " " + league[0]['rank'] + " | Queue: " + league[0]['queueType'].gsub('_', ' ')
                + "\nName: " + league[1]['leagueName'] + " | Tier: " + league[1]['tier'] + " " + league[1]['rank'] + " | Queue: " + league[1]['queueType'].gsub('_', ' ')
end

#####################################
##                                 ##
##        Items info Request       ##
##                                 ##
#####################################

@bot.command(:item, description: 'Gives information about an specific item', usage: '!item item_name') do |*args|
  event = args.shift
  item_name = args.join(' ')

  # Request Item data
  items_data = @taric.static_items(item_list_data: "sanitizedDescription").body['data']

  # Loop through items and find requested item
  item = {}

  items_data.each do |k, v|
    if v['name'] == item_name
      item = v
    end
  end

  # Checks if the item data is saved (exists)
  if item.empty?
    event.respond "`Are you sure that's the right name of an item?`"
  else
    # Return Item basic data
    event.respond "Item: " + item['name']+ "\n\nDescription: " + item['sanitizedDescription'] + "\n\nSmall Info: " + item['plaintext']
  end
end

#####################################
##                                 ##
##     Summoner Current Match      ##
##                                 ##
#####################################

@bot.command(:current_game, description: 'Gives information about a summoner current match', usage: '!current_game summoner_name') do |*args|
  event = args.shift
  summoner_name = args.join(' ')

  # Request Summoner ID
  summoner_id = @taric.summoner_by_name(summoner_name: summoner_name).body['id']

  # Request Summoner current Match
  current_match = @taric.current_game(summoner_id: summoner_id).body

  puts current_match

  # Save summoner on each side
  blueTeam = []
  redTeam = []

  # Check if there's a current match
  if current_match['participants']
    current_match['participants'].each do |summoner|
      if summoner['teamId'] == 100
        blueTeam.push(summoner['summonerName'])
      else
        redTeam.push(summoner['summonerName'])
      end
    end

    # Shows current match data (Summoner names for each team)
    #event.respond "Blue Team: " + blueTeam.join(', ') + "\nRed Team: " + redTeam.join(', ')
    event.respond "```css
#BlueTeam
> #{blueTeam[0]}
> #{blueTeam[1]}
> #{blueTeam[2]}
> #{blueTeam[3]}
> #{blueTeam[4]}
```" + "\n```css
[RedTeam]
> #{redTeam[0]}
> #{redTeam[1]}
> #{redTeam[2]}
> #{redTeam[3]}
> #{redTeam[4]}
```"
  else
    # If there's no active game return this message
    event.respond "`There's no current game active.`"
  end

end

# Run Bot
@bot.run

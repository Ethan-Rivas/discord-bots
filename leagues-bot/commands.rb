Encoding.default_external = Encoding::UTF_8

# Require Gnar Bot
require './gnar-bot'

# Require this for create http requests
require 'uri'
require 'net/http'

# Here's where the magic happens
league_token = 'RGAPI-7e12becc-b66c-4413-b6b6-3ef13c334391'

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

@bot.command(:league, description: 'Returns the current division of a Summoner (Use %20 insted of whitespaces)', usage: '!league summoner') do |event, summoner_name|
  summoner = Net::HTTP.get URI("https://la1.api.riotgames.com/lol/summoner/v3/summoners/by-name/" + summoner_name + "?api_key=" + league_token)

  data = JSON.parse(summoner)
  data_id = data['id'].to_s

  league = Net::HTTP.get URI("https://la1.api.riotgames.com/lol/league/v3/positions/by-summoner/" + data_id + "?api_key=" + league_token)
  league_data = JSON.parse(league)

  event.respond "Summoner: " + league_data[0]['playerOrTeamName'] + "\nName: " + league_data[0]['leagueName'] +  " | Tier: " + league_data[0]['tier'] + " " + league_data[0]['rank'] + " | Queue: " + league_data[0]['queueType'].gsub('_', ' ')
                + "\nName: " + league_data[1]['leagueName'] + " | Tier: " + league_data[1]['tier'] + " " + league_data[1]['rank'] + " | Queue: " + league_data[1]['queueType'].gsub('_', ' ')

end

# Run Bot
@bot.run

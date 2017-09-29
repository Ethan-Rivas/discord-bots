# Require Discord Ruby API
require 'discordrb'
require './commands'

# Launch Bot
@bot = Discordrb::Commands::CommandBot.new(token: 'MzYzMDE0NDM5MDg1MTQ2MTEz.DK7KHg.OAJpQGBsJb1gOFZJmLRAOnWpwYs', client_id: 363014439085146113, prefix: '!')

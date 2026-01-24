#json from https://gist.github.com/oliveratgithub/0bf11a9aff0d6da7b46f1490f86a71eb/?h=1#file-emojis-json
# and
# https://raw.githubusercontent.com/paragbhadoria/emoji.json/master/emoji.js
# Thanks to them !

require 'json'
json_string = File.read("emoji.json")
emojiJSON = JSON.parse(json_string)

$shortEmoji = emojiJSON.invert

def getEmoji(shortCode)
  $shortEmoji[shortCode] || "🔷"
end

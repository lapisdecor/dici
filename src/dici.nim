import std/httpclient
import std/json
import std/[xmlparser, xmltree]
import std/parseopt

var fim = false

proc exit() =
  fim = true

when isMainModule:

  var word = "error"
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      word = key
    of cmdLongOption:
      if key == "help":
        echo "Uso: dici palavra"
        exit()
        break
      else:
        discard
    of cmdShortOption:
      if key == "h":
        echo "Uso: dici palavra"
        exit()
        break
      else:
        discard
    of cmdEnd:
      discard

  if fim:
    quit()

  var response = ""
  var client = newHttpClient()

  try:
    response = client.getContent("https://api.dicionario-aberto.net/word/" & word)
    if response == "[]":
      exit()
  finally:
    client.close()

  if fim:
    echo "A palavra não está no dicionário"
    quit()


  let myJson = parseJson(response)

  var myXML = myJson[0]["xml"].getStr()
  #echo myXML
  var x = parseXml(myXML)
  var list = x.findAll("def")
  let k = list.len() - 1
  #echo x.findAll("def")[1].innerText
  for i in 0..k:
    echo list[i].innerText

import std/httpclient
import std/json
import std/[xmlparser, xmltree]
import std/parseopt

var fim = false

proc exit() =
  echo "A palavra não está no dicionário"
  fim = true

when isMainModule:

  var word = "error"
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      word = key
    of cmdLongOption, cmdShortOption:
      discard
    of cmdEnd:
      discard
  var response = ""
  var client = newHttpClient()
  try:
    response = client.getContent("https://api.dicionario-aberto.net/word/" & word)
    if response == "[]":
      exit()
  finally:
    client.close()

  if fim:
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

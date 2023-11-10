import json
import sys
import random
import string
import os
import requests


def print_list(json_string):
  '''
  This function takes a JSON string as input, parses it into a list of items,
  injects short codes into each item, and prints the items to the terminal.
  If an item is highlighted, it's printed in a different color.
  '''

  # clearing the terminal ensures that the list
  # can take up the whole screen
  clear_terminal()

  # get the terminal dimensions so we can trim
  # the list to fit
  # dimensions = shutil.get_terminal_size()
  dimensions = os.get_terminal_size()

  # text color constants
  GREEN = "\033[92m"
  UNDERLINE = "\033[4m"
  ENDC = "\033[0m"

  items = json.loads(json_string)
  # print("number of items: " + str(len(items)))
  # print("terminal dimensions: " + str(dimensions))

  # check every item for the required keys (title, subtitle, highlight, url)
  if not validate_items(items):
    return None

  # keep a print stack so we can trim the list to fit
  print_stack = []

  items = listef_inject_short_codes(items)
  for item in items:
    # if the print stack is too big, stop adding items
    # this will save computing resources
    if len(print_stack) > dimensions.lines:
      break

    title = truncate(item["title"], dimensions.columns)
    subtitle = truncate(item["subtitle"], dimensions.columns)
    highlight = item["highlight"] == "true" or item["highlight"] == True
    short_code = item["short_code"]

    # if the item is highlighted, print it with a different color
    if highlight:
      print_stack.append(UNDERLINE + title + ENDC)
      print_stack.append(GREEN + subtitle + ENDC)
    else:
      print_stack.append(title)
      print_stack.append(subtitle)

    if short_code is not None:
      horizontal_rule = ("-" * (dimensions.columns - len('['+short_code+']'))) + '[' + short_code + ']'
      print_stack.append(horizontal_rule)
    else:
      print_stack.append("-" * dimensions.columns)

  # trim the print stack to fit the terminal
  print_stack = print_stack[:dimensions.lines - 1] # remove 1 for the prompt/cursor
  for line in print_stack:
    print(line)


def validate_items(items):
  for item in items:
    for key in ["title", "subtitle", "highlight", "url"]:
      if key not in item:
        print("Error: " + key + " missing")
        print("Item: " + str(item))
        return False
  return True

# injects the short codes into the list
def listef_inject_short_codes(items):
  '''
  This function takes a list of items, extracts the URLs,
  generates short codes for each URL,
  and injects the short codes back into the items.
  '''
  # use the plural ef_urls_to_short_codes because it's more efficient
  # than calling ef_url_to_short_code multiple times
  urls = [item["url"] for item in items]
  short_codes = ef_urls_to_short_codes(urls)

  for i in range(len(items)):
    items[i]["short_code"] = short_codes[i]

  return items


def ef_path():
  # return the path to the ef json file
  # ~/.ef.json
  return os.path.join(os.path.expanduser("~"), ".ef.json")


def ef_init():
  # check if the file exists
  if not os.path.exists(ef_path()):
    # create the file and initialize it to an empty json object
    with open(ef_path(), "w") as file:
      file.write("{}")
  return None


def ef_store(url):
  '''
  This function takes a URL, generates a short code for it,
  and stores the short code and URL in a JSON file.
  If the URL is already stored, it returns the existing short code.
  '''

  # read the json file
  with open(ef_path(), "r") as file:
    json_string = file.read()

  # parse the json string into a python object
  json_object = json.loads(json_string)

  # check if the url is already in the object
  if url in json_object.values():
    # if it is, return the short code
    return ef_url_to_short_code(url)

  # generate a random short code
  short_code = random_string(2)

  # if short_code is already in the json object, let it overwrite
  # this is infrequent and ensures that the json file stays small

  # add the short code and url to the object
  json_object[short_code] = url

  # write the object back to the file
  with open(ef_path(), "w") as file:
    file.write(json.dumps(json_object))

  return short_code


def ef_short_code_to_url(short_code):
  '''
  This function takes a short code, reads the JSON file,
  and returns the corresponding URL.
  If the short code doesn't exist, it returns None.
  '''

  try:
    # read the json file
    with open(ef_path(), "r") as file:
      json_string = file.read()
    json_object = json.loads(json_string)
  except:
    # delete the file and re-initialize it
    os.remove(ef_path())
    ef_init()
    return None

  # if the short code isn't in the json file, return None
  return json_object[short_code] if short_code in json_object else None


def ef_url_to_short_code(url):
  '''
  This function takes a URL and returns the corresponding short code.
  If the URL doesn't exist, it generates a new short code and stores it.
  '''
  return ef_urls_to_short_codes([url])[0]


def ef_urls_to_short_codes(urls):
  '''
  This function takes a list of URLs and returns a list of corresponding short codes.
  If a URL doesn't exist, it generates a new short code and stores it.
  '''

  try:
    # read the json file
    with open(ef_path(), "r") as file:
      json_string = file.read()
    json_object = json.loads(json_string)
  except:
    # delete the file and re-initialize it
    os.remove(ef_path())
    ef_init()
    return [None] * len(urls)

  short_codes = []

  # loop through each url
  for url in urls:
    if url is None:
      short_codes.append(None)
    # if the url isn't in the json file, return a newly stored short code
    elif url not in json_object.values():
      short_codes.append(ef_store(url))
    else:
      # if the url is in the json file, get the short code
      short_code = [key for key, value in json_object.items() if value == url][0]
      short_codes.append(short_code)

  return short_codes


def random_string(length):
  '''
  This function generates a random string of a given length.
  '''
  return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(length))


def truncate(string, length):
  '''
  This function truncates a string to a given length.
  '''
  if len(string) > length:
    return string[:length - 3] + "..."
  else:
    return string


def clear_terminal():
  '''
  This function clears the terminal.
  '''
  print("\033c")


if __name__ == "__main__":
  ef_init()

  command = sys.argv[1]

  if command == "list":
    # accepts .json http url as an argument to get the json_st
    json_string = requests.get(sys.argv[2]).text
    print_list(json_string)
  elif command == "ef":
    # output the url to stdout
    print(ef_short_code_to_url(sys.argv[2]))
  else:
    print("Invalid command")
    print("Usage: listef list < json")
    print("Usage: listef ef <short_code>")

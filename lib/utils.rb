# posts directory
POSTS = "./posts"

def create_post(content)
  digest = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
  return false if File.exist? POSTS + "/#{digest}"

  # create the actual file
  filename = digest
  fh = File.open(POSTS + "/#{filename}", "w")
  fh.write(content)
  fh.close

  return filename
end

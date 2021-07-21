require 'sinatra'
require 'cgi'

require_relative 'lib/utils.rb'

# static html documents directory
HTDOCS = "./htdocs"

#######routes########

# index
['/', '/index.html', '/index', ''].each do |path|
  get path do
    # fetch and return the index view
    return File.read(HTDOCS + "/index.html").sub("{CONTENT}", "")
  end
end


# create
post '/create' do
  content = params["content"]

  # halt returns an error and returns from the function
  halt(400, "Empty paste") if content == ''

  # create_post returns a post_id which is also the name
  # of the file that the document is saved as.
  # if there was an error, it returns false.
  post = create_post(content)

  # finally, if the post was created, redirect to it, else
  # throw a server error
  if post
    redirect(POSTS + "/#{post}")
  else
    halt(500)
  end
end

# get
get '/posts/:post' do |post|
  # if the file with the post ID could not be located, redirect to 
  # the index page
  redirect('/') unless File.exists?(POSTS + "/#{post}")
  
  # HTML escape the content to prevent artifacts and stored XSS 
  # attacks during the rendering of the content 
  content = CGI.escape_html(File.read(POSTS + "/#{post}"))

  # fetch the rendrer
  renderer = File.read(HTDOCS + "/render.html")
  # finally combine both of them
  rendered = renderer.sub("{PLACEHOLDER}", content).sub("{POSTID}", post)

  return rendered
end

# edit
get '/edit/:post' do |post|
  # if the file with the post ID could not be located, redirect to 
  # the index page 
  redirect('/') unless File.exists?(POSTS + "/#{post}")

  # fetch the document content from the file
  content = File.read(POSTS + "/#{post}")

  # preload the editor component with the content and return it to 
  # the client
  return File.read(HTDOCS + "/index.html").sub("{CONTENT}", content)
end


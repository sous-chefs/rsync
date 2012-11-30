

include_recipe "rsync::server"

#simple server this directory up read only
rsync_serve "tmp" do 
  path "/tmp"
  read_only true
  uid "nobody"
  gid "nobody"
end


